package io.spring.api.security;

import static java.util.Arrays.asList;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Profile("!dev")
@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

  @Value("${spring.h2.console.enabled:false}")
  private boolean h2ConsoleEnabled;

  @Bean
  public JwtTokenFilter jwtTokenFilter() {
    return new JwtTokenFilter();
  }

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    if (h2ConsoleEnabled) {
      http.authorizeHttpRequests(authorize -> authorize
          .requestMatchers("/h2-console", "/h2-console/**").permitAll())
          .headers(headers -> headers.frameOptions(frameOptions -> frameOptions.sameOrigin()));
    }

    http.csrf(csrf -> csrf.disable())
        .cors(cors -> cors.configurationSource(corsConfigurationSource()))
        .exceptionHandling(exceptionHandling -> 
            exceptionHandling.authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
        .sessionManagement(sessionManagement -> 
            sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(authorize -> authorize
            .requestMatchers(HttpMethod.OPTIONS).permitAll()
            .requestMatchers(HttpMethod.GET, "/articles/feed").authenticated()
            .requestMatchers(HttpMethod.POST, "/users", "/users/login").permitAll()
            .requestMatchers(HttpMethod.GET, "/articles/**", "/profiles/**", "/tags").permitAll()
            .anyRequest().authenticated())
        .addFilterBefore(jwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

    return http.build();
  }

  @Bean
  public CorsConfigurationSource corsConfigurationSource() {
    final CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(asList("http://localhost:4200"));
    configuration.setAllowedMethods(
        asList("HEAD", "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
    // setAllowCredentials(true) is important, otherwise:
    // The value of the 'Access-Control-Allow-Origin' header in the response must not be the
    // wildcard '*' when the request's credentials mode is 'include'.
    configuration.setAllowCredentials(true);
    // setAllowedHeaders is important! Without it, OPTIONS preflight request
    // will fail with 403 Invalid CORS request
    configuration.setAllowedHeaders(
        asList(
            "Authorization",
            "Cache-Control",
            "Content-Type",
            "drill-session-id",
            "drill-test-name"));
    final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
  }
}
