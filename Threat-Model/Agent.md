snxx ini bukan lah tools scanner (untuk versi tahap awal)
Web Application Threat Modeling Assistant

Berikut rancangan tools keamanan untuk pentester yang strict mengikuti 4 spesifikasi yang kamu kasih: Signal Ontology (SOS), Layer Taxonomy (LTS), Knowledge State (KSS), dan Hypothesis Semantics (HSS). Ini bukan “scanner yang menebak”, tapi reasoning engine deterministik: observasi → distabilkan jadi knowledge → baru boleh inferensi → wajib ada proof chain.

Saya namain project ini: SNXX (Phase 1: Framework Intelligence Engine) sesuai dokumen ide kamu. Source
0) Prinsip inti (anti-halusinasi)

Tool ini dilarang langsung menyimpulkan dari raw signal/evidence. Mesin inference hanya menerima input KnowledgeGraph. Kalau melanggar → epistemic breach. Source

Domain observasi juga dibatasi keras: hanya yang muncul dari Network Interaction → Observable Artifact → Recorded Representation. Tidak boleh pakai “pengetahuan bawaan model”, DB CVE eksternal, atau korelasi training untuk dijadikan signal. Source
1) Output yang dihasilkan tool (yang akan kamu pakai sebelum Burp)

Tool menghasilkan 3 hal:

    SignalGraph (murni observasional, belum ada makna teknologi) Source
    KnowledgeGraph (facts yang sudah stabil, contested, stale, negative facts, exclusive sets, stability lingkungan) Source
    Inference Report (hypothesis + confidence + status + proof chain + constraint layer) Source

2) Arsitektur modul SNXX (sesuai “calculus”, bukan heuristik)

Mengikuti sketsa pipeline yang ada di dokumen kamu: Collector → Normalizer → Signal Extractor → Layer Segmentation → Knowledge Builder → Hypothesis Engine → Hypothesis Competition → Security Reasoner → (opsional) LLM Narrator. LLM tidak boleh jadi sumber reasoning; hanya narator. Source
Modul A — Collector (HTTP/TLS Observer)

Melakukan interaksi jaringan terkontrol: GET/HEAD/OPTIONS, fetch robots.txt, fetch resource tertentu, probe error page terukur, dsb.
Modul B — Normalizer (Deterministik)

Normalisasi wajib deterministik: trim, lowercase header key, collapse spasi, decode gzip sebelum ekstraksi, buang nonce/token acak, canonical newline. Kalau tidak bisa dinormalisasi → tidak boleh jadi signal. Source
Modul C — Signal Extractor (SOS)

Menghasilkan objek Signal yang field-nya closed (tidak boleh nambah field):
uid, class, source, feature, value, precision, stability, timestamp. Source

Juga membentuk ObservationFrame, relasi (CO_OCCURS/REPEATS/MUTATES/EXCLUDES/DERIVES_FROM), bundle, conflict, negative signal, entropy annotation. Source
Modul D — Layer Segmentation (LTS)

Setiap fact/signal harus ditempatkan ke layer jalur request–response: EDGE_EXTERNAL → EDGE_PROXY → APP_INTERFACE → APP_LOGIC → RUNTIME → SYSTEM. Source

Constraint penting:

    Fakta dari EDGE_EXTERNAL (mis. CDN header) tidak boleh memunculkan hipotesis framework backend. Source
    Resolusi konflik “Django vs Laravel” hanya sah jika konfliknya di layer yang sama (mis. sama-sama APP_LOGIC). Source

Modul E — Knowledge State Builder (KSS)

Mengubah SignalGraph → KnowledgeGraph dengan aturan:

    Signal → Evidence → Knowledge (hierarki epistemik) Source
    Evidence butuh structural validity + observability integrity + reproducibility (minimal re-observation). Source
    Knowledge harus stabil lintas frame dan kalau conflict → contested dan belum boleh dipakai inference. Source
    Ada TTL/decay: stale knowledge forbidden untuk inference. Source

Output final modul ini wajib berbentuk KnowledgeGraph { facts[], contested[], stale[], negative_facts[], exclusive_sets[], environment_stability } dan hanya ini input legal untuk inference. Source
Modul F — Hypothesis Engine (HSS)

Hypothesis hanya boleh dibuat via Rule (tidak ada improvisasi / “regex → framework”). Source

Model hipotesis fixed: id, target, supporting_facts, contradicting_facts, rule_id, confidence, status (tidak boleh field lain). Source

Target mencakup: TECHNOLOGY, FRAMEWORK, RUNTIME, SERVER, LIBRARY, SECURITY_CONTROL, MISCONFIGURATION. Source

Confidence deterministik: Σ(rule_weight × fact_confidence) − Σ(conflict_penalty) dibatasi 0..1. Source

Status: CANDIDATE/SUPPORTED/CONTESTED/BLOCKED/CONFIRMED/REJECTED dengan threshold contoh yang sudah kamu tulis. Source

Wajib ada ProofChain: fact → rule → hypothesis → conclusion. Tanpa ini output dianggap tidak sah. Source
3) “Tool keamanan” yang kamu minta: fitur CLI v1 (Phase 1)

Di bawah ini definisi fitur yang realistis dan sesuai spesifikasi (bukan “vuln 100%”).
3.1 Perintah CLI yang disarankan

    snxx observe <url>
    Output: SignalGraph (JSON) + frames ringkas.
    snxx knowledge build <signalgraph.json>
    Output: KnowledgeGraph (JSON).
    snxx infer <knowledgegraph.json>
    Output: hypothesis list + proof chain + layer constraints + contested sets.
    snxx report <infer.json>
    Output: laporan teks untuk “briefing officer” pentester (tanpa menambah reasoning baru).

Ini menjaga batas: inference tidak bisa lompat dari raw signal ke kesimpulan. Source Source
3.2 Mekanisme “framework + versi”

Dokumen kamu sendiri melarang “header match tunggal → version claim” dan melarang shortcut. Jadi:

    deteksi framework boleh muncul sebagai hypothesis berbasis rule dari facts di layer minimal APP_INTERFACE. Source
    versi framework butuh layer minimal APP_LOGIC. Source

Kalau bukti cuma dari EDGE_EXTERNAL/EDGE_PROXY, confidence harus dipenalize atau status diblok (tergantung rule exclusions). Source
3.3 Negative inference (sangat penting untuk threat modeling)

Tool harus bisa membentuk hipotesis dari absence yang stabil, misalnya absence(CSP) → missing_security_control, tapi hanya kalau stabilitas tinggi. Source
Dan negative knowledge memang bagian KSS (ketiadaan yang stabil) untuk narrowing hypothesis. Source
4) Rule DSL (inti “calculus” yang bisa kamu koding)

Karena HSS mewajibkan semua hypothesis lewat rule dan FactPattern tidak boleh fuzzy/embedding, kamu butuh DSL sederhana:

    Rule { rule_id, preconditions, exclusions, weight } Source
    FactPattern hanya boleh: (feature == value), AND/OR, absence(feature), dan stability >= threshold. Source

Contoh konsep rule (bukan isi faktual dari target tertentu):

    Preconditions: beberapa facts dari APP_INTERFACE/APP_LOGIC (bukan dari EDGE_EXTERNAL)
    Exclusions: facts yang menunjukkan kontradiksi pada layer yang sama
    Weight: angka tetap

Hasilnya deterministic dan bisa diaudit.
5) Yang bisa saya buatkan sebagai deliverable “siap coding”

Kalau kamu setuju, saya bisa lanjut menuliskan (dalam satu paket):

    Struktur folder project (Go atau Python)
    Schema JSON untuk Signal, ObservationFrame, KnowledgeGraph, Hypothesis, ProofChain
    Implementasi awal:
        HTTP collector
        normalizer
        signal extractor minimal (headers/status/body token/pattern)
        knowledge stabilizer (re-observation, conflict, TTL sederhana)
        rule engine + scoring deterministic + status mapping
        report generator CLI

implementasi.
1. python
2. linux
3. HTTP + tls.

SNXX (Phase 1) — Blueprint “Calulus, bukan tebakan”
1) Pipeline modul (hard boundary)

    Collector (HTTP+TLS interaction)
    Normalizer (deterministik)
    Signal Extractor → bentuk SignalGraph
    Layer Tagger → semua signal/fact ditempatkan ke Layer
    Knowledge Builder → bentuk KnowledgeGraph (facts stabil + contested + stale + negative)
    Hypothesis Engine (rule-based) → hypothesis + confidence + status
    ProofChain + Report (audit trail wajib)

Batas keras yang harus kamu enforce di code:

    Hypothesis Engine hanya boleh menerima KnowledgeGraph, bukan raw signal/evidence. Kalau tidak: epistemic breach. Source
    Signal hanya berasal dari “network interaction → observable artifact → recorded representation”, bukan lookup CVE / database / asumsi model. Source

2) CLI Commands (MVP yang usable untuk pentester)

Struktur perintah yang saya sarankan:
snxx observe

snxx observe https://target.tld --frames 3 --tls --out signalgraph.json
Output: SignalGraph (frames + signals + relations + conflicts + entropy).
snxx knowledge

snxx knowledge build signalgraph.json --out knowledgegraph.json
Output: KnowledgeGraph sesuai KSS (facts/contested/stale/negative/exclusive_sets/environment_stability). Source
snxx infer

snxx infer knowledgegraph.json --rules rules/ --out inference.json
Output: hypothesis list + status + confidence + proof chain (no shortcut). Source
snxx report

snxx report inference.json --format text
Output: briefing untuk pentester: “apa yang mungkin benar + kenapa + batas keyakinannya + konflik”.
3) Data Model (JSON schema ringkas, patuh dokumen)
3.1 Signal (SOS)

Wajib field ini saja (closed vocabulary):
uid, class, source, feature, value, precision, stability, timestamp Source

Contoh JSON (ilustratif):

{
  "uid": "sig-001",
  "class": "TOKEN",
  "source": "RESPONSE_HEADER",
  "feature": "HEADER_KEY",
  "value": "server",
  "precision": "NORMALIZED",
  "stability": "INSTANCE",
  "timestamp": 1730000000
}

3.2 ObservationFrame (SOS)

Satu request menghasilkan satu frame berisi banyak signal. Re-observation menghasilkan frame berbeda walau sinyal sama. Source
3.3 KnowledgeGraph (KSS)

Output modul knowledge state harus:

{
  "facts": [],
  "contested": [],
  "stale": [],
  "negative_facts": [],
  "exclusive_sets": [],
  "environment_stability": 0.0
}

Dan ini satu-satunya input legal untuk inference. Source
3.4 Hypothesis (HSS)

Field wajib dan tidak boleh nambah: id, target, supporting_facts, contradicting_facts, rule_id, confidence, status Source
4) Collector: HTTP + TLS (yang benar-benar “observable”)
HTTP observables (contoh yang aman)

    Response status code, headers, body token/pattern, redirect target, cookies
    OPTIONS untuk method support
    robots.txt / security.txt sebagai ARTIFACT fetch

Ini cocok dengan SourceType dan FeatureType di SOS (mis. RESPONSE_HEADER/STATUS_CODE/RESOURCE_FETCH). Source
TLS observables (CONNECTION_METADATA)

Tambahkan observasi TLS sebagai signal:

    TLS version negotiated
    Cipher suite
    Cert subject/issuer, SAN, notBefore/notAfter
    ALPN (h2/http1.1)

Ini tetap “protocol-derived” dan masuk domain SOS. Source

Implementasi Python yang umum (kamu pilih salah satu):

    httpx untuk HTTP probing
    ssl + socket untuk TLS handshake metadata

5) Normalizer (deterministik; wajib)

Normalizer wajib melakukan hal yang disebut SOS:

    trim whitespace, lowercase header key, collapse spaces, decode gzip sebelum ekstraksi, remove nonce/token acak, canonical newline.
    Kalau tidak bisa dinormalisasi → discard (bukan signal). Source

6) Layer Tagging (LTS) — mencegah “CDN dianggap backend”

Setiap fact harus punya layer dari taksonomi: EDGE_EXTERNAL → EDGE_PROXY → APP_INTERFACE → APP_LOGIC → RUNTIME → SYSTEM Source

Aturan praktis untuk MVP (deterministik, bukan AI):

    Signal yang jelas CDN/WAF header → EDGE_EXTERNAL
    “proxy-ish / hop behavior / rewriting” → EDGE_PROXY
    routing behavior, method handling, CSRF rejection response → APP_INTERFACE
    template rendering, serialization error, validation message → APP_LOGIC
    stack trace language / exception format → RUNTIME
    path separator / OS-ish quirks → SYSTEM
    (Ini selaras contoh LTS, dan yang paling penting: constraint-nya.) Source

Compatibility matrix yang harus kamu enforce:

    Framework minimal APP_INTERFACE
    Framework version minimal APP_LOGIC
    Language runtime minimal RUNTIME
    Server software minimal EDGE_PROXY Source

7) Knowledge Builder (KSS) — “kapan boleh disebut fakta”

Rules MVP yang wajib:

    Structural validity (parseable) Source
    Observability integrity (tidak truncated/timeout) Source
    Reproducibility: minimal re-observation
    seen_once → tentative, seen_twice → evidence (kecuali volatile) Source

Stability requirement default: >= 3 observation frames atau >= 2 frame + repeats + no conflict. Source

Conflict:

    Jika konflik → contested dan belum boleh dipakai inference. Source

TTL/decay:

    Knowledge bisa stale kalau gap besar/volatility tinggi → stale tidak boleh dipakai inference. Source

8) Hypothesis Engine (HSS) — rule DSL deterministik

Kunci: tidak boleh shortcut seperti “regex → framework” atau “single header → version claim”. Semua lewat Rule. Source
8.1 Rule format (YAML/JSON)

Rule harus punya:

    rule_id
    preconditions: FactPattern[]
    exclusions: FactPattern[]
    weight: float Source

FactPattern hanya boleh:

    (feature == value)
    AND/OR
    absence(feature)
    stability >= threshold
    No fuzzy string, no embedding similarity. Source

8.2 Confidence + status

Confidence: Σ(rule_weight × fact_confidence) − Σ(conflict_penalty) dibatasi 0..1. Source

Status set sesuai threshold contoh (candidate/supported/contested/confirmed) dan blocked jika exclusion terpenuhi. Source
8.3 ProofChain (wajib)

Setiap conclusion/hypothesis harus bisa ditrace: fact → rule → hypothesis → conclusion. Tanpa itu “tidak sah”. Source
9) Scope “Security Output” yang benar untuk Phase-1

Agar tidak melanggar boundary “tidak pakai CVE DB eksternal” dan tidak overclaim:

    Tool boleh menghasilkan hypothesis:
        framework/runtime/server/misconfiguration/security_control (target enum HSS) Source
    Tool tidak bilang “vuln 100%”
    Tool memberi arah manual testing berbasis temuan (mis. “missing CSP” sebagai negative fact inference) Source

# note untuk kimi, ini adalah hasil output oleh genspark untuk hasil 'Source' adalah bagian dari 
Signal Ontology → vocabulary observasi
Layer Taxonomy → topologi sistem target
Knowledge State → epistemic state machine
Hypothesis Semantics → inference calculus

Baik. Dengan setelan final kamu:

    Output default pretty + human-readable
    Re-observation default 3 frames

Di bawah ini saya kasih skeleton repo + spesifikasi file + contoh rules + contoh output JSON (semua deterministik, dan menjaga batas: Signal → Knowledge → Hypothesis). Ini implementasi SNXX Phase-1 (Framework Intelligence Engine) untuk Linux dengan HTTP + TLS.

Rujukan spesifikasi yang kamu beri: Signal Ontology (SOS) Source
Layer Taxonomy (LTS) Source
Knowledge State (KSS) Source
Hypothesis Semantics (HSS) Source
1) SNXX — Struktur Proyek (Python, Linux)

snxx/
  pyproject.toml
  README.md
  src/snxx/
    __init__.py
    cli.py

    collector/
      http_collector.py
      tls_collector.py

    normalize/
      normalizer.py

    signal/
      model.py
      extractor_http.py
      extractor_tls.py
      relations.py
      graph.py

    layer/
      taxonomy.py
      tagger.py

    knowledge/
      model.py
      builder.py
      stability.py
      ttl.py

    hypothesis/
      model.py
      rule_dsl.py
      engine.py
      proofchain.py

    report/
      render_text.py

  rules/
    framework_core.yaml
    security_controls.yaml
    runtime.yaml

  examples/
    sample_signalgraph.pretty.json
    sample_knowledgegraph.pretty.json
    sample_inference.pretty.json

Kenapa dipecah begini: biar hard boundary-nya “tidak mungkin” kebobolan (Hypothesis Engine tidak bisa baca raw signal). Itu requirement eksplisit di HSS & KSS. Source Source
2) CLI — Command yang kamu jalankan
2.1 Observe → bikin SignalGraph (SOS)

snxx observe https://target.tld \
  --frames 3 \
  --timeout 12 \
  --tls \
  --pretty \
  --out signalgraph.pretty.json

SignalGraph adalah output observasional: frames + signals + relations + conflicts + entropy + negative signal, tanpa inference. Source
2.2 Knowledge build → bikin KnowledgeGraph (KSS)

snxx knowledge build signalgraph.pretty.json \
  --pretty \
  --out knowledgegraph.pretty.json

Output harus berbentuk KnowledgeGraph { facts, contested, stale, negative_facts, exclusive_sets, environment_stability } dan jadi satu-satunya input legal untuk inference. Source
2.3 Infer → rule engine (HSS + LTS constraint)

snxx infer knowledgegraph.pretty.json \
  --rules ./rules \
  --pretty \
  --out inference.pretty.json

Hypothesis hanya boleh muncul via Rule (tidak ada shortcut regex→framework / single-header→version). Source
2.4 Report (briefing)

snxx report inference.pretty.json --format text

Catatan: report ini “narasi hasil reasoning”, bukan sumber reasoning baru (sesuai arah desain kamu di snxx-docs). Source
3) Data Model (patuh “closed vocabulary”)
3.1 Signal (SOS)

Objek Signal wajib field ini dan tidak boleh tambahan: uid, class, source, feature, value, precision, stability, timestamp Source

Nilai enum mengacu pada SOS (SignalClass, SourceType, FeatureType, PrecisionType, StabilityType). Source
3.2 Hypothesis (HSS)

Objek Hypothesis wajib: id, target, supporting_facts, contradicting_facts, rule_id, confidence, status (tidak boleh field lain). Source
3.3 Layer (LTS)

Layer ordering yang kamu enforce: EDGE_EXTERNAL → EDGE_PROXY → APP_INTERFACE → APP_LOGIC → RUNTIME → SYSTEM Source

Dan compatibility matrix minimal layer (mis. Framework minimal APP_INTERFACE; Framework Version minimal APP_LOGIC; Runtime minimal RUNTIME). Source
4) Rules DSL — YAML deterministik (inti “calculus”)

HSS mewajibkan: Hypothesis hanya lewat Rule, FactPattern tidak boleh fuzzy/embedding, hanya (feature==value), AND/OR, absence(feature), stability>=threshold. Source

Contoh format rules/framework_core.yaml:

rules:
  - rule_id: FW_APP_INTERFACE_ROUTE_STYLE_01
    target: FRAMEWORK
    hypothesis_value: "express_like_router"
    weight: 0.35
    min_layer: APP_INTERFACE
    preconditions:
      all:
        - fact: "http.method_support"
          op: "contains"
          value: "GET"
        - fact: "http.status_code"
          op: "in"
          value: [404, 405]
        - fact: "stability_score"
          op: ">="
          value: 0.66
    exclusions:
      any:
        - fact: "environment_stability"
          op: "<"
          value: 0.6

Catatan penting:

    min_layer adalah enforcement LTS: kalau fact asalnya di layer lebih luar, confidence dipenalize atau rule tidak dieksekusi (pilih salah satu kebijakan, saya sarankan “rule blocked”). LTS menyatakan inference tidak sah bila lompat layer. Source
    environment_stability diambil dari KnowledgeGraph (KSS). Jika rendah, inference forbidden. Source

Kalau kamu mau super ketat, kamu bisa bikin engine: kalau min_layer tidak terpenuhi → status BLOCKED (menggunakan mekanisme exclusions/blocked di HSS). Source
5) MVP Observations — HTTP + TLS yang “legal” (SOS)
5.1 HTTP probes (Collector)

Minimal set (aman dan deterministic):

    GET /
    HEAD /
    OPTIONS /
    GET /robots.txt
    GET /security.txt (optional)
    GET /nonexistent-<uuid> untuk memancing error format (APP_INTERFACE/APP_LOGIC fingerprint), tapi tetap dicatat sebagai observasi, bukan kesimpulan.

Semua hasil diubah jadi Signal via normalizer + extractor. Domain ini sesuai SOS. Source
5.2 TLS probes

Dengan Python ssl, kamu ambil:

    negotiated TLS version
    cipher suite
    cert subject/issuer
    SAN list (dibuat atomic, bukan kalimat)
    validity dates

Semua itu masuk CONNECTION_METADATA / TLS_FIELD dsb sesuai vocabulary SOS. Source
6) Knowledge Builder — aturan stabilisasi (KSS)

Kamu set default --frames 3, selaras requirement stability default KSS (>=3 frames). Source

Checklist KSS yang MVP harus jalankan:

    Structural validity (parseable, RFC-valid header, DOM-consistent untuk HTML kalau kamu parse) Source
    Observability integrity (no timeout, no truncated) Source
    Reproducibility: seen_once tentative; minimal seen_twice evidence; lalu jadi knowledge jika stabil (default 3 frames). Source
    Conflict: jika conflict → contested dan belum boleh inference. Source
    TTL/decay: jika expired → stale dan forbidden. Source

7) Inference Engine — status, confidence, proof chain (HSS)

    Confidence deterministik: Σ(rule_weight × fact_confidence) − Σ(conflict_penalty) dibatasi 0..1. Source

    Status: CANDIDATE/SUPPORTED/CONTESTED/BLOCKED/CONFIRMED/REJECTED (threshold contoh di HSS). Source

    Negative inference: absence(CSP) AND stability high → missing_security_control (contoh eksplisit HSS). Source

    ProofChain wajib ada untuk setiap conclusion/hypothesis. Source

8) Contoh Output (pretty JSON) — format yang kamu pilih

Berikut contoh bentuk (bukan isi fakta target tertentu).
8.1 SignalGraph (ringkas)

{
  "frames": [
    {
      "frame_id": "0d3c...",
      "interaction_type": "GET_ROOT",
      "timestamp": 1730000000,
      "signals": [
        {
          "uid": "sig-001",
          "class": "TOKEN",
          "source": "RESPONSE_HEADER",
          "feature": "HEADER_KEY",
          "value": "server",
          "precision": "NORMALIZED",
          "stability": "INSTANCE",
          "timestamp": 1730000000
        }
      ]
    }
  ],
  "relations": [
    {
      "type": "REPEATS",
      "from": "sig-001",
      "to": "sig-001",
      "strength": 1.0
    }
  ],
  "conflicts": [],
  "entropy": {
    "sig-001": 0.1
  }
}

Model frame/relations/conflict/entropy mengikuti SOS Part 2. Source
8.2 KnowledgeGraph

{
  "facts": [
    {
      "fact_id": "fact-01",
      "feature": "http.header.server",
      "value": "nginx",
      "layer": "EDGE_PROXY",
      "knowledge_confidence": 0.92,
      "stability_score": 1.0,
      "observations": 3
    }
  ],
  "contested": [],
  "stale": [],
  "negative_facts": [],
  "exclusive_sets": [],
  "environment_stability": 0.95
}

Struktur mengikuti output KSS (facts/contested/stale/negative/exclusive_sets/environment_stability). Source
8.3 Inference

{
  "hypotheses": [
    {
      "id": "hyp-01",
      "target": "SERVER",
      "supporting_facts": ["fact-01"],
      "contradicting_facts": [],
      "rule_id": "SRV_EDGE_PROXY_SERVER_HEADER_01",
      "confidence": 0.62,
      "status": "SUPPORTED"
    }
  ],
  "proof_chains": [
    {
      "hypothesis_id": "hyp-01",
      "chain": [
        { "fact": "fact-01" },
        { "rule": "SRV_EDGE_PROXY_SERVER_HEADER_01" },
        { "hypothesis": "hyp-01" }
      ]
    }
  ]
}

Hypothesis object model & proof chain wajib sesuai HSS. Source
9) Implementasi nyata (langkah berikutnya)

Kalau kamu bilang “lanjut”, saya akan tulis kode skeleton (siap jalan) untuk:

    snxx observe (httpx + ssl handshake)
    normalizer deterministik (sesuai SOS)
    extractor HTTP+TLS → SignalGraph
    knowledge builder (3-frame stability + conflict + TTL minimal)
    rule engine YAML → hypothesis + confidence + status + proofchain
    pretty JSON writer (default)

# akhir cerita memakai HTTPX
