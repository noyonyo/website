#!/usr/bin/env zsh

# Global variable to track if interrupted
vite_interrupted=false

# Signal handler
handle_interrupt() {
    echo "\nCaught interrupt signal. Stopping server..."
    vite_interrupted=true
    if [[ -n $vite_pid ]]; then
        kill $vite_pid 2>/dev/null
        wait $vite_pid 2>/dev/null
    fi
    
    # Clean up hosts on interrupt
    echo "Cleaning up hosts..."
    if [[ -n $HOST ]]; then
        echo "Removing host mapping: $HOST"
        sudo hostile remove "$HOST" 2>/dev/null || true
    fi
    npm run --silent clear-hosts 2>/dev/null || true
}

# Function to check if port 443 is in use for listening
check_port_443() {
    # Check if any process is listening on port 443
    local listening_processes=$(lsof -i:443 2>/dev/null | grep "LISTEN")
    if [[ -n $listening_processes ]]; then
        echo "Found processes listening on port 443:"
        echo "$listening_processes"
        return 0
    fi

    # Use a more direct approach to find listening processes
    local listening_check=$(sudo lsof -i :443 | grep LISTEN)
    if [[ -n $listening_check ]]; then
        echo "Found process listening on port 443:"
        echo "$listening_check"
        echo ""
        echo "⚠️  Another development server is already running!"
        return 0
    fi

    return 1
}

# Function to kill the development server listening on port 443
kill_port_443_process() {
    echo "Looking for process listening on port 443..."
    local listening_info=$(sudo lsof -i :443 | grep LISTEN)

    if [[ -n $listening_info ]]; then
        local listening_pid=$(echo "$listening_info" | awk '{print $2}')
        local process_user=$(echo "$listening_info" | awk '{print $3}')

        if [[ -n $listening_pid && $listening_pid =~ ^[0-9]+$ ]]; then
            echo "Killing process PID $listening_pid (user: $process_user)..."

            # First try graceful shutdown
            if sudo kill -TERM $listening_pid 2>/dev/null; then
                echo "  Sent SIGTERM, waiting 3 seconds for graceful shutdown..."
                sleep 3

                # Check if still running
                if kill -0 $listening_pid 2>/dev/null; then
                    echo "  Process still running, using SIGKILL..."
                    sudo kill -9 $listening_pid 2>/dev/null
                    sleep 1
                fi
            else
                echo "  SIGTERM failed, using SIGKILL..."
                sudo kill -9 $listening_pid 2>/dev/null
                sleep 1
            fi

            # Verify it's gone
            if sudo lsof -i :443 | grep -q "LISTEN"; then
                echo "Warning: Process might still be using port 443"
                return 1
            else
                echo "Successfully killed listening process"
                return 0
            fi
        else
            echo "Invalid PID found: $listening_pid"
            return 1
        fi
    else
        echo "No process found listening on port 443"
        return 1
    fi
}

# Function to ask user what to do about port 443
handle_port_443_conflict() {
    echo "⚠️  Port 443 conflict detected!"

    # Check if it's a listening process first
    local listening_process=$(lsof -i:443 2>/dev/null | grep "LISTEN" | head -1)
    if [[ -n $listening_process ]]; then
        echo "Process listening on port 443: $listening_process"
    else
        echo "This is likely another instance of this development server."
    fi

    echo ""
    echo "What would you like to do?"
    echo "1) Kill conflicting processes"
    echo "2) Return to environment selection"
    echo "3) Exit"
    echo ""

    while true; do
        echo -n "Please choose (1/2/3): "
        read choice
        case $choice in
            1)
                if kill_port_443_process; then
                    return 0
                else
                    echo "Failed to kill process. Returning to environment selection..."
                    return 1
                fi
                ;;
            2)
                echo "Returning to environment selection..."
                return 1
                ;;
            3)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter 1, 2, or 3."
                ;;
        esac
    done
}

start_env() {
    echo "Starting $env environment"

    # Debug environment variables
    echo "Loading environment from: environment/.env.$env"
    if [[ -f "environment/.env.$env" ]]; then
        echo ""
    else
        echo "ERROR: Environment file not found!"
        return 1
    fi

    # shellcheck disable=SC1090
    source "./environment/.env.$env" set +o allexport
    
    # Construct the hostname from environment variables (matching Vite config)
    if [[ -n "$VITE_APP_SUBDOMAIN" && -n "$VITE_DOMAIN" ]]; then
        HOST="$VITE_APP_SUBDOMAIN.$VITE_DOMAIN"
    elif [[ -n "$HOST" ]]; then
        # Use HOST if explicitly set in environment file
        HOST="$HOST"
    else
        # Fallback to localhost
        HOST="localhost"
    fi
    
    echo "Setting up host mapping: 127.0.0.1 -> $HOST"
    sudo hostile set 127.0.0.1 "$HOST"
    export NODE_OPTIONS=--max-old-space-size=4048

    if check_port_443; then
        if ! handle_port_443_conflict; then
            # User chose to return to environment selection or we failed to kill the process
            echo "Failed to resolve port conflict"
            return 1
        fi
    fi

    # Set up signal trap
    trap handle_interrupt SIGINT
    vite_interrupted=false

    local final_check=$(lsof -i:443 2>/dev/null | grep "LISTEN")
    if [[ -n $final_check ]]; then
        echo "ALERT: Process started listening on port 443 after our initial check!"
        echo "$final_check"
        if ! handle_port_443_conflict; then
            return 1
        fi
    fi

    sudo npx dotenv -e "environment/.env.$env" vite &
    vite_pid=$!
    echo "Vite started with PID: $vite_pid"

    # Wait for vite to finish
    wait $vite_pid
    local exit_code=$?

    # Remove trap
    trap - SIGINT

    # Clean up hosts regardless of exit reason
    echo "Cleaning up hosts..."
    if [[ -n $HOST ]]; then
        echo "Removing host mapping: $HOST"
        sudo hostile remove "$HOST" 2>/dev/null || true
    fi
    npm run --silent clear-hosts

    # If we caught an interrupt, return 130
    if [[ $vite_interrupted == true ]]; then
        return 130
    fi

    return $exit_code
}

if [ -z "$1" ]
    then
        while :
        do
            npx tsx --tsconfig ./tsconfig.node.json  ./scripts/select-environment.ts
            file="env.temp"
            if [ -f "$file" ]
                then
                    env=$(<"$file")
                    rm -f "$file"
                    start_env
                    exit_code=$?
                    echo "Process exited with code: $exit_code"
                    # Continue loop if Ctrl+C was pressed (exit code 130) or any non-zero exit
                    if [ $exit_code -ne 0 ]; then
                        echo "Server stopped. Returning to environment selection..."
                        continue
                    else
                        echo "Normal exit. Stopping script."
                        break
                    fi
                    else
                        break
                fi
        done

    else
        env=$1
        start_env
fi
