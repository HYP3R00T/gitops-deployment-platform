/**
 * API helper utilities for backend communication
 * Simple fetch wrappers with error handling
 */

export interface ApiResponse<T> {
    ok: boolean;
    data?: T;
    error?: string;
}

/**
 * Fetch from backend API endpoint
 * Returns both data and error in a simple object to avoid exceptions
 */
export async function fetchApi<T>(
    endpoint: string,
    baseUrl: string
): Promise<ApiResponse<T>> {
    try {
        const url = `${baseUrl}${endpoint}`;
        const response = await fetch(url);

        if (!response.ok) {
            return {
                ok: false,
                error: `Backend returned status ${response.status}`,
            };
        }

        const data = await response.json();
        return {
            ok: true,
            data,
        };
    } catch (error) {
        const message =
            error instanceof Error ? error.message : "Unknown error occurred";
        return {
            ok: false,
            error: message,
        };
    }
}
