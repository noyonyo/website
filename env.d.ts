/// <reference types="vite/client" />

import { EnvType } from "./src/enum/EnvType";

interface ImportMetaEnv {
    readonly VITE_ENVIRONMENT: EnvType;
    readonly VITE_DOMAIN: string;
    readonly VITE_APP_SUBDOMAIN: string;
    readonly VITE_API_SUBDOMAIN: string;
}

interface ImportMeta {
    readonly env: ImportMetaEnv;
}
