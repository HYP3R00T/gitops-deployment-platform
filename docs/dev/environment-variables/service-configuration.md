# Service Configuration

## PUBLIC_API_URL

Specifies the API endpoint URL for the web service.

**Usage:**

- Web service uses this to connect to the API
- Set at container build time (compiled into JavaScript by Astro or Vite)
- Examples: `http://api:8000` (container to container), `http://localhost:8001` (browser), `https://api.example.com` (production)

**Note:** Astro bakes this into the build, so changing it at runtime has no effect. See [Web Service Container Build](../../services/web.md#container-build) for details.
