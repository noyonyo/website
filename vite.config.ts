import {defineConfig} from 'vite'
import react from '@vitejs/plugin-react'
import checker from 'vite-plugin-checker'
import tsconfigPaths from 'vite-tsconfig-paths'
import svgr from 'vite-plugin-svgr'
import mkcert from 'vite-plugin-mkcert'

// https://vite.dev/config/
export default defineConfig({
    plugins: [
        react(),
        tsconfigPaths(), // Enables TypeScript path mapping
        svgr({
            svgrOptions: {
                plugins: ["@svgr/plugin-svgo", "@svgr/plugin-jsx"],
                svgoConfig: {
                    plugins: [
                        {
                            name: 'preset-default',
                            params: {
                                overrides: {
                                    removeViewBox: false, // Preserve viewBox for proper scaling
                                    cleanupIds: {
                                        minify: false,
                                    },
                                    mergePaths: false, // Avoid merging paths to maintain structure
                                },
                            },
                        },
                        'sortAttrs', // Sort attributes for consistency
                    ],
                },
            },
        }), // Enables importing SVGs as React components with SVGO optimization
        mkcert({hosts: ['localhost', `${process.env.VITE_APP_SUBDOMAIN}.${process.env.VITE_DOMAIN}`]}), // HTTPS for custom domains
        checker({
            typescript: true
            // ESLint disabled in dev server - run manually with 'npm run lint'
        })
    ],
    server: {
        strictPort: true,
        host: '0.0.0.0', // Accept connections from any host
        port: 443
    }
})
