#!/usr/bin/env zsh

# Global variable to track if interrupted
build_interrupted=false

# Signal handler
handle_interrupt() {
    echo "\nCaught interrupt signal. Stopping build..."
    build_interrupted=true
    if [[ -n $build_pid ]]; then
        kill $build_pid 2>/dev/null
        wait $build_pid 2>/dev/null
    fi
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

# Function to perform the build process
build_env() {
    echo "Building $env environment"

    # Validate environment file exists
    echo "Loading environment from: environment/.env.$env"
    if [[ ! -f "environment/.env.$env" ]]; then
        echo "ERROR: Environment file environment/.env.$env not found!"
        return 1
    fi

    # Check for port conflicts before building
    if check_port_443; then
        if ! handle_port_443_conflict; then
            echo "Port conflict not resolved. Aborting build."
            return 1
        fi
    fi

    # Set up signal trap for graceful shutdown
    trap handle_interrupt SIGINT
    build_interrupted=false

    # Save current tsconfig if it exists
    if test -f "./tsconfig.app.json"; then
        echo "Saving current tsconfig.app.json to temp file"
        cp -f "./tsconfig.app.json" "./tsconfig.app.json.temp"
    fi

    echo "Replacing tsconfig.app.json with tsconfig.$env.json"
    
    # Validate target tsconfig exists
    if [[ ! -f "./tsconfig.$env.json" ]]; then
        echo "ERROR: Target tsconfig file ./tsconfig.$env.json not found!"
        return 1
    fi
    
    cp -f "./tsconfig.$env.json" "./tsconfig.app.json"

    # Perform the build
    echo "Starting build process..."
    if [ "$env" == "mock" ]; then
        dotenv -v VITE_SKIP_LOGIN=false -v VITE_HIDE_MIRAGE_LOGS=true -e "environment/.env.$env" vite build &
    else
        dotenv -e "environment/.env.$env" vite build &
    fi
    
    build_pid=$!
    echo "Build started with PID: $build_pid"

    # Wait for build to finish
    wait $build_pid
    local exit_code=$?

    # Remove trap
    trap - SIGINT

    # Restore tsconfig
    if test -f "./tsconfig.app.json.temp"; then
        echo "Restoring tsconfig.app.json from temp file"
        cp -f "./tsconfig.app.json.temp" "./tsconfig.app.json"
        echo "Removing temp file"
        rm -f "./tsconfig.app.json.temp"
    else
        echo "Restoring tsconfig.app.json from base config"
        cp -f "./tsconfig.base.json" "./tsconfig.app.json"
    fi

    # Check if build was interrupted
    if [[ $build_interrupted == true ]]; then
        echo "Build was interrupted"
        return 130
    fi

    if [ $exit_code -eq 0 ]; then
        echo "Build finished successfully and environment restored"
    else
        echo "Build failed with exit code: $exit_code"
    fi

    return $exit_code
}

# Main script logic
if [ -z "$1" ]; then
    while :; do
        npx tsx --tsconfig ./tsconfig.node.json ./scripts/select-environment.ts
        file="env.temp"
        if [ -f "$file" ]; then
            env=$(<"$file")
            rm -f "$file"
            build_env
            exit_code=$?
            echo "Build process exited with code: $exit_code"
            
            # Continue loop if interrupted (exit code 130) or any non-zero exit
            if [ $exit_code -ne 0 ]; then
                echo "Build failed or was interrupted. Returning to environment selection..."
                continue
            else
                echo "Build completed successfully."
                break
            fi
        else
            break
        fi
    done
else
    env=$1
    build_env
fi
