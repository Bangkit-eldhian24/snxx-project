########################################
# SNXX Stage-1 Core Inference Rules
# Scope: Architecture & Mechanism Model
########################################


########################################
# SIGNAL DECLARATIONS
########################################

signal header.server : edge;
signal header.via : edge;
signal tls.certificate_issuer : edge;

signal header.authorization : application;
signal cookie.session_id : application;
signal body.csrf_token : application;

signal header.content_type : application;
signal response.redirect : gateway;


########################################
# HYPOTHESIS DECLARATIONS
########################################

hypothesis infrastructure.cdn {
    layer: edge;
    prior: 0.30;
}

hypothesis architecture.layered {
    layer: gateway;
    prior: 0.40;
}

hypothesis auth.token_based {
    layer: application;
    prior: 0.35;
}

hypothesis auth.server_session {
    layer: application;
    prior: 0.50;
}

hypothesis interface.api_json {
    layer: application;
    prior: 0.30;
}

hypothesis interface.form_based {
    layer: application;
    prior: 0.40;
}


########################################
# RULES
########################################


########################################
# CDN Detection
########################################

rule detect_cdn_from_server_header {
    when header.server contains "cloudflare"
         or header.server contains "akamai"
         or header.server contains "fastly";
    then increase infrastructure.cdn by 0.25;
}


rule detect_cdn_from_tls_issuer {
    when tls.certificate_issuer contains "Cloudflare";
    then increase infrastructure.cdn by 0.20;
}


########################################
# Layered Architecture
########################################

rule detect_layered_from_via_header {
    when present(header.via);
    then increase architecture.layered by 0.20;
}


rule layered_if_cdn_and_redirect {
    when infrastructure.cdn > 0.50
         and present(response.redirect);
    then increase architecture.layered by 0.15;
}


########################################
# Authentication Model
########################################

rule detect_token_auth {
    when present(header.authorization)
         and absent(cookie.session_id);
    then increase auth.token_based by 0.25;
}


rule detect_server_session_auth {
    when present(cookie.session_id)
         and absent(header.authorization);
    then increase auth.server_session by 0.25;
}


rule csrf_implies_session_model {
    when present(body.csrf_token)
         and present(cookie.session_id);
    then increase auth.server_session by 0.15;
}


########################################
# Interface Model
########################################

rule detect_json_api_interface {
    when header.content_type contains "application/json";
    then increase interface.api_json by 0.25;
}


rule detect_form_interface {
    when present(body.csrf_token)
         and absent(header.authorization);
    then increase interface.form_based by 0.20;
}


########################################
# Conflict Dampening
########################################

rule auth_conflict_dampening {
    when auth.token_based > 0.60
         and auth.server_session > 0.60;
    then decrease auth.token_based by 0.15;
}
