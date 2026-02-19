AHS/00-Subsystem-Contract.md
1. Purpose
Adaptive Heuristic Subsystem (AHS) bertindak sebagai behavioral control layer yang:
mengevaluasi risiko operasional
memodifikasi bobot hipotesis arsitektur
menentukan batas interaksi
mencegah eskalasi prematur
AHS tidak menghasilkan kesimpulan arsitektur.
AHS hanya mengontrol bagaimana kesimpulan diuji.

2. Design Constraints
AHS wajib memenuhi batas berikut:
Tidak membaca raw HTTP payload langsung
Tidak membuat hipotesis baru
Tidak mengubah Knowledge-State secara langsung
Hanya boleh memodifikasi:
hypothesis weight
probe policy
exploration priority
abort flag
Jika salah satu batas ini dilanggar → subsystem invalid.

3. Input Contract
AHS hanya menerima Signal Bundle terstruktur dari Observation-Stratum.

3.1 Signal Bundle Schema
SignalBundle:
    timestamp
    route_id
    interaction_type
    response_class
    state_transition
    entropy_score
    timing_profile
    anomaly_vector
    reflection_pattern
    header_variance
    redirect_behavior

Penjelasan Field Penting
| Field              | Makna                                  |
| ------------------ | -------------------------------------- |
| response_class     | 2xx, 3xx, 4xx, 5xx pattern abstraction |
| state_transition   | apakah state berubah                   |
| entropy_score      | kompleksitas payload terhadap baseline |
| anomaly_vector     | deviasi dari baseline sistem           |
| reflection_pattern | apakah input muncul kembali            |
| header_variance    | perubahan header antar request         |
| timing_profile     | konsistensi delay                      |
AHS tidak tahu “React” atau “Node”.
AHS hanya tahu sinyal perilaku.

4. Output Contract
AHS menghasilkan HeuristicDirective.

4.1 Directive Schema
HeuristicDirective:
    threat_posture
    probe_policy
    risk_delta
    hypothesis_weight_modifier
    exploration_priority_shift
    abort_flag
threat_posture
normal
hardened
monitored
deceptive
probe_policy
passive
gentle
controlled
restricted


Stage-1 maksimum = gentle
risk_delta
Nilai numerik yang mengurangi atau menambah risk budget.
hypothesis_weight_modifier
Contoh:
GraphQL hypothesis: -0.12
Decoy endpoint: +0.30
AHS tidak membuat node baru, hanya menggeser bobot.
exploration_priority_shift
Mengubah urutan investigasi tanpa menciptakan jalur baru.
abort_flag
Boolean.
Jika true → semua probing dihentikan.

5. Execution Flow
Observation-Stratum
        ↓
SignalBundle
        ↓
AHS Evaluation
        ↓
HeuristicDirective
        ↓
Reasoning-Stratum
Reasoning wajib membaca directive sebelum mengambil tindakan.

6. Isolation Rule
AHS harus stateless terhadap konten eksploitasi.
Ia hanya menyimpan:
risk_budget_state
threat_posture_state
signal_history_window
Tidak boleh menyimpan payload eksploitasi.

7. Stage-01 Boundary
Selama Stage-01 aktif:
probe_policy ∈ {passive, gentle}
Jika AHS mencoba menaikkan ke controlled → pelanggaran stage.

8. Failure Condition
Subsystem dianggap gagal jika:
threat_posture tidak berubah meskipun anomaly tinggi
risk_budget tidak pernah berkurang
abort_flag tidak pernah aktif dalam kondisi deception pattern
Dampak Desain Ini
Dengan kontrak ini:
Cognitive-Strata tetap bersih
Epistemic-Law tetap murni
Stage-01 menjadi terkontrol
AHS tidak berubah menjadi scanner liar
