package com.inspectionapp.backend.dto.response;

/**
 * Returned by {@code POST /api/v1/auth/login} on successful authentication.
 *
 * <p>Clients store the {@code token} and include it in every subsequent request
 * as an HTTP header:
 * <pre>
 *   Authorization: Bearer &lt;token&gt;
 * </pre>
 *
 * @param token    the signed JWT (compact serialisation)
 * @param type     always {@code "Bearer"} — the token type expected by the
 *                 {@code Authorization} header scheme
 * @param username the authenticated user's login handle
 * @param role     the user's role ({@code ADMIN} or {@code INSPECTOR}),
 *                 stripped of the {@code ROLE_} prefix
 */
public record JwtResponse(
        String token,
        String type,
        String username,
        String role
) {
}
