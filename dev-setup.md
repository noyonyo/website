# Local Development with Custom Domains

This setup allows you to develop with production-like domains locally using HTTPS.

## Setup (One-time)

1. **Install mkcert (if not already installed):**
   ```bash
   # macOS
   brew install mkcert
   
   # Windows  
   choco install mkcert
   ```

2. **Install local CA:**
   ```bash
   mkcert -install
   ```

3. **Setup domain mappings:**
   ```bash
   npm run dev:setup
   ```
       This maps:
    - `dev.nyo.solutions` → `127.0.0.1:443`
    - `www.nyo.solutions` → `127.0.0.1:443`

## Usage

**Start development server:**
```bash
npm run dev
```

**Access your app:**
- 🔒 `https://dev.nyo.solutions` (development domain)
- 🔒 `https://www.nyo.solutions` (production domain)
- 🔒 `https://localhost` (fallback)

## Cleanup

**Remove domain mappings:**
```bash
npm run dev:cleanup
```

**List current mappings:**
```bash
npm run dev:list
```

## Benefits

- ✅ **Production-like URLs** - Test with real domain structure
- ✅ **Valid HTTPS** - No certificate warnings
- ✅ **Domain-specific cookies** - Test authentication flows
- ✅ **CORS testing** - Verify cross-origin requests
- ✅ **Subdomain routing** - Test multi-tenant features 