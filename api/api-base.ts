
export const API_ENDPOINTS = {
    STATIC_ASSETS: `${import.meta.env.VITE_API_SUBDOMAIN}.${import.meta.env.VITE_DOMAIN}/${import.meta.env.VITE_ENVIRONMENT}`,
    SERVICES: `${import.meta.env.VITE_SERVICES_SUBDOMAIN}.${import.meta.env.VITE_DOMAIN}/${import.meta.env.VITE_ENVIRONMENT}`
} as const;
