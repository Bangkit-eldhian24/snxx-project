# DSL/rules/stage1.foundation.dsl

# Minimal rules required to construct a valid ASG

# Stage-01: Architecture inference only

# No vulnerability semantics

# No vendor certainty claims

# --------------------------------------------------

# EDGE LAYER — reverse proxy / CDN presence

# --------------------------------------------------

signal header.server : edge;
signal header.via : edge;
signal header.x_forwarded_for : edge;

hypothesis edge.reverse_proxy {
layer: edge;
prior: 0.20;
}

rule edge_proxy_headers {
when present(header.via) and present(header.x_forwarded_for);
then increase edge.reverse_proxy by 0.30;
}

rule edge_server_generic {
when header.server contains "proxy";
then increase edge.reverse_proxy by 0.25;
}

# --------------------------------------------------

# GATEWAY LAYER — routing / API mediation

# --------------------------------------------------

signal path.api_prefix : gateway;
signal header.x_api_version : gateway;

hypothesis gateway.api_gateway {
layer: gateway;
prior: 0.15;
}

rule api_prefix_pattern {
when present(path.api_prefix);
then increase gateway.api_gateway by 0.30;
}

rule api_version_header {
when present(header.x_api_version);
then increase gateway.api_gateway by 0.25;
}

# --------------------------------------------------

# APPLICATION LAYER — dynamic web runtime

# --------------------------------------------------

signal header.content_type_html : application;
signal response.template_marker : application;

hypothesis app.dynamic_rendering {
layer: application;
prior: 0.25;
}

rule html_response_render {
when header.content_type_html contains "text/html";
then increase app.dynamic_rendering by 0.20;
}

rule template_artifact_detected {
when present(response.template_marker);
then increase app.dynamic_rendering by 0.30;
}

# --------------------------------------------------

# AUTH LAYER — session based identity

# --------------------------------------------------

signal cookie.session_id : auth;
signal response.set_cookie : auth;
signal redirect.login : auth;

hypothesis auth.session_based {
layer: auth;
prior: 0.20;
}

rule session_cookie_seen {
when present(cookie.session_id);
then increase auth.session_based by 0.35;
}

rule login_redirect_flow {
when present(redirect.login) and present(response.set_cookie);
then increase auth.session_based by 0.30;
}

# --------------------------------------------------

# STATEFULNESS — request correlation

# --------------------------------------------------

signal response.cache_control : runtime;
signal response.etag : runtime;

hypothesis runtime.stateful_interaction {
layer: runtime;
prior: 0.15;
}

rule cache_variation_indicator {
when present(response.etag);
then increase runtime.stateful_interaction by 0.20;
}

rule no_store_behavior {
when response.cache_control contains "no-store";
then increase runtime.stateful_interaction by 0.25;
}
