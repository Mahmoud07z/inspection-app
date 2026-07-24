package com.inspectionapp.backend.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Stateless utility for creating, parsing, and validating JSON Web Tokens.
 *
 * <h2>Token structure</h2>
 * <pre>
 *   Header  : { "alg": "HS256", "typ": "JWT" }
 *   Payload : {
 *     "sub"   : "&lt;username&gt;",
 *     "roles" : ["ROLE_INSPECTOR"],
 *     "iat"   : &lt;issued-at epoch seconds&gt;,
 *     "exp"   : &lt;expiry epoch seconds&gt;
 *   }
 *   Signature: HMAC-SHA256( base64(header) + "." + base64(payload), secret )
 * </pre>
 *
 * <h2>Key size</h2>
 * The secret configured in {@code app.jwt.secret} must decode to at least
 * 32 bytes (256 bits) to satisfy the HMAC-SHA256 minimum key length.
 */
@Component
public class JwtUtil {

    /**
     * Base64-encoded HMAC-SHA256 signing secret.
     * Injected from {@code app.jwt.secret} in {@code application.properties}.
     */
    @Value("${app.jwt.secret}")
    private String secret;

    /**
     * Token validity window in milliseconds.
     * Defaults to 86 400 000 (24 hours) if the property is absent.
     */
    @Value("${app.jwt.expiration-ms:86400000}")
    private long expirationMs;

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    /**
     * Generates a signed JWT for the given principal.
     *
     * <p>The token includes the {@code sub} (subject = username), the user's
     * authorities as a {@code roles} claim, and the standard {@code iat} /
     * {@code exp} timestamps.
     *
     * @param userDetails the authenticated principal
     * @return compact JWT string: {@code header.payload.signature}
     */
    public String generateToken(UserDetails userDetails) {
        Map<String, Object> extraClaims = new HashMap<>();
        extraClaims.put("roles", userDetails.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .toList());
        return buildToken(extraClaims, userDetails.getUsername());
    }

    /**
     * Extracts the {@code sub} claim (username) from a token.
     *
     * @param token compact JWT string
     * @return the subject embedded in the token
     * @throws JwtException if the token is malformed, expired, or has an invalid signature
     */
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    /**
     * Returns {@code true} when the token's subject matches the given
     * {@link UserDetails} and the token has not expired.
     *
     * @param token       compact JWT string
     * @param userDetails the principal to validate against
     */
    public boolean isTokenValid(String token, UserDetails userDetails) {
        String username = extractUsername(token);
        return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
    }

    // -------------------------------------------------------------------------
    // Internal helpers
    // -------------------------------------------------------------------------

    /**
     * Builds and signs the compact JWT.
     */
    private String buildToken(Map<String, Object> extraClaims, String subject) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);

        return Jwts.builder()
                .claims(extraClaims)
                .subject(subject)
                .issuedAt(now)
                .expiration(expiry)
                .signWith(signingKey())
                .compact();
    }

    /**
     * Parses the token and applies {@code claimsResolver} to the payload.
     *
     * @throws JwtException on any parsing / validation failure
     */
    private <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    /**
     * Parses and verifies the token, returning the full claims map.
     *
     * <p>JJWT 0.12.x: {@code parseSignedClaims} replaces the deprecated
     * {@code parseClaimsJws}.
     *
     * @throws JwtException if the signature is invalid, the token is expired,
     *                      or the compact string is malformed
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(signingKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Decodes the Base64 secret and wraps it in an HMAC-SHA256 {@link SecretKey}.
     */
    private SecretKey signingKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Returns {@code true} when the token's {@code exp} claim is in the past.
     */
    private boolean isTokenExpired(String token) {
        Date expiry = extractClaim(token, Claims::getExpiration);
        return expiry.before(new Date());
    }

}
