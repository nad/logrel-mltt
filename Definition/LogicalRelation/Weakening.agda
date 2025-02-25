open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Weakening
  {a} (M : Set a) {{eqrel : EqRelSet M}} where

open EqRelSet {{...}}

open import Definition.Untyped M as U hiding (wk ; _∷_)
open import Definition.Untyped.Properties M
open import Definition.Typed M
open import Definition.Typed.Properties M
open import Definition.Typed.Weakening M as T hiding (wk; wkEq; wkTerm; wkEqTerm)
open import Definition.LogicalRelation M
open import Definition.LogicalRelation.Irrelevance M

open import Tools.Nat
open import Tools.Product
import Tools.PropositionalEquality as PE
open import Tools.Reasoning.PropositionalEquality

private
  variable
    m n : Nat
    ρ : Wk m n
    Δ : Con Term m
    Γ : Con Term n

-- Weakening of neutrals in WHNF

wkTermNe : ∀ {k A} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
         → Γ ⊩neNf k ∷ A → Δ ⊩neNf U.wk ρ k ∷ U.wk ρ A
wkTermNe {ρ = ρ} [ρ] ⊢Δ (neNfₜ neK ⊢k k≡k) =
  neNfₜ (wkNeutral ρ neK) (T.wkTerm [ρ] ⊢Δ ⊢k) (~-wk [ρ] ⊢Δ k≡k)

wkEqTermNe : ∀ {k k′ A} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
           → Γ ⊩neNf k ≡ k′ ∷ A → Δ ⊩neNf U.wk ρ k ≡ U.wk ρ k′ ∷ U.wk ρ A
wkEqTermNe {ρ = ρ} [ρ] ⊢Δ (neNfₜ₌ neK neM k≡m) =
  neNfₜ₌ (wkNeutral ρ neK) (wkNeutral ρ neM) (~-wk [ρ] ⊢Δ k≡m)

-- Weakening of reducible natural numbers

mutual
  wkTermℕ : ∀ {n} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
          → Γ ⊩ℕ n ∷ℕ → Δ ⊩ℕ U.wk ρ n ∷ℕ
  wkTermℕ {ρ = ρ} [ρ] ⊢Δ (ℕₜ n d n≡n prop) =
    ℕₜ (U.wk ρ n) (wkRed:*:Term [ρ] ⊢Δ d)
       (≅ₜ-wk [ρ] ⊢Δ n≡n)
       (wkNatural-prop [ρ] ⊢Δ prop)

  wkNatural-prop : ∀ {n} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
                 → Natural-prop Γ n
                 → Natural-prop Δ (U.wk ρ n)
  wkNatural-prop ρ ⊢Δ (sucᵣ n) = sucᵣ (wkTermℕ ρ ⊢Δ n)
  wkNatural-prop ρ ⊢Δ zeroᵣ = zeroᵣ
  wkNatural-prop ρ ⊢Δ (ne nf) = ne (wkTermNe ρ ⊢Δ nf)

mutual
  wkEqTermℕ : ∀ {t u} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
            → Γ ⊩ℕ t ≡ u ∷ℕ
            → Δ ⊩ℕ U.wk ρ t ≡ U.wk ρ u ∷ℕ
  wkEqTermℕ {ρ = ρ} [ρ] ⊢Δ (ℕₜ₌ k k′ d d′ t≡u prop) =
    ℕₜ₌ (U.wk ρ k) (U.wk ρ k′) (wkRed:*:Term [ρ] ⊢Δ d)
        (wkRed:*:Term [ρ] ⊢Δ d′) (≅ₜ-wk [ρ] ⊢Δ t≡u)
        (wk[Natural]-prop [ρ] ⊢Δ prop)

  wk[Natural]-prop : ∀ {n n′} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
                   → [Natural]-prop Γ n n′
                   → [Natural]-prop Δ (U.wk ρ n) (U.wk ρ n′)
  wk[Natural]-prop ρ ⊢Δ (sucᵣ [n≡n′]) = sucᵣ (wkEqTermℕ ρ ⊢Δ [n≡n′])
  wk[Natural]-prop ρ ⊢Δ zeroᵣ = zeroᵣ
  wk[Natural]-prop ρ ⊢Δ (ne x) = ne (wkEqTermNe ρ ⊢Δ x)

-- Empty
wkTermEmpty : ∀ {n} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
  → Γ ⊩Empty n ∷Empty → Δ ⊩Empty U.wk ρ n ∷Empty
wkTermEmpty {ρ = ρ} [ρ] ⊢Δ (Emptyₜ n d n≡n (ne prop)) =
  Emptyₜ (U.wk ρ n) (wkRed:*:Term [ρ] ⊢Δ d)
     (≅ₜ-wk [ρ] ⊢Δ n≡n)
     (ne (wkTermNe [ρ] ⊢Δ prop))

wk[Empty]-prop : ∀ {n n′} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
  → [Empty]-prop Γ n n′
  → [Empty]-prop Δ (U.wk ρ n) (U.wk ρ n′)
wk[Empty]-prop ρ ⊢Δ (ne x) = ne (wkEqTermNe ρ ⊢Δ x)

wkEqTermEmpty : ∀ {t u} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
  → Γ ⊩Empty t ≡ u ∷Empty
  → Δ ⊩Empty U.wk ρ t ≡ U.wk ρ u ∷Empty
wkEqTermEmpty {ρ = ρ} [ρ] ⊢Δ (Emptyₜ₌ k k′ d d′ t≡u prop) =
  Emptyₜ₌ (U.wk ρ k) (U.wk ρ k′) (wkRed:*:Term [ρ] ⊢Δ d)
      (wkRed:*:Term [ρ] ⊢Δ d′) (≅ₜ-wk [ρ] ⊢Δ t≡u)
      (wk[Empty]-prop [ρ] ⊢Δ prop)

-- Unit
wkTermUnit : ∀ {n} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
           → Γ ⊩Unit n ∷Unit → Δ ⊩Unit U.wk ρ n ∷Unit
wkTermUnit {ρ = ρ} [ρ] ⊢Δ (Unitₜ n d prop) =
  Unitₜ (U.wk ρ n) (wkRed:*:Term [ρ] ⊢Δ d) (wkWhnf ρ prop)

wkEqTermUnit : ∀ {t u} → ρ ∷ Δ ⊆ Γ → (⊢Δ : ⊢ Δ)
          → Γ ⊩Unit t ≡ u ∷Unit
          → Δ ⊩Unit U.wk ρ t ≡ U.wk ρ u ∷Unit
wkEqTermUnit {ρ = ρ} [ρ] ⊢Δ (Unitₜ₌ ⊢t ⊢u) =
  Unitₜ₌ (T.wkTerm [ρ] ⊢Δ ⊢t) (T.wkTerm [ρ] ⊢Δ ⊢u)

-- Weakening of the logical relation

wk : ∀ {m} {ρ : Wk m n} {Γ : Con Term n} {Δ A l} → ρ ∷ Δ ⊆ Γ → ⊢ Δ → Γ ⊩⟨ l ⟩ A → Δ ⊩⟨ l ⟩ U.wk ρ A
wk ρ ⊢Δ (Uᵣ′ l′ l< ⊢Γ) = Uᵣ′ l′ l< ⊢Δ
wk ρ ⊢Δ (ℕᵣ D) = ℕᵣ (wkRed:*: ρ ⊢Δ D)
wk ρ ⊢Δ (Emptyᵣ D) = Emptyᵣ (wkRed:*: ρ ⊢Δ D)
wk ρ ⊢Δ (Unitᵣ D) = Unitᵣ (wkRed:*: ρ ⊢Δ D)
wk {ρ = ρ} [ρ] ⊢Δ (ne′ K D neK K≡K) =
  ne′ (U.wk ρ K) (wkRed:*: [ρ] ⊢Δ D) (wkNeutral ρ neK) (~-wk [ρ] ⊢Δ K≡K)
wk {m = m} {ρ} {Γ} {Δ} {A} {l} [ρ] ⊢Δ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) =
  let ⊢ρF = T.wk [ρ] ⊢Δ ⊢F
      [F]′ : ∀ {k} {ρ : Wk k m} {ρ′ E} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
           → E ⊩⟨ l ⟩ U.wk ρ (U.wk ρ′ F)
      [F]′ {_} {ρ} {ρ′} [ρ] [ρ′] ⊢E = irrelevance′
                              (PE.sym (wk-comp ρ ρ′ F))
                              ([F] ([ρ] •ₜ [ρ′]) ⊢E)
      [a]′ : ∀ {k} {ρ : Wk k m} {ρ′ E a} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
             ([a] : E ⊩⟨ l ⟩ a ∷ U.wk ρ (U.wk ρ′ F) / [F]′ [ρ] [ρ′] ⊢E)
           → E ⊩⟨ l ⟩ a ∷ U.wk (ρ • ρ′) F / [F] ([ρ] •ₜ [ρ′]) ⊢E
      [a]′ {_} {ρ} {ρ′} [ρ] [ρ′] ⊢E [a] = irrelevanceTerm′ (wk-comp ρ ρ′ F)
                                          ([F]′ [ρ] [ρ′] ⊢E) ([F] ([ρ] •ₜ [ρ′]) ⊢E) [a]
      [G]′ : ∀ {k} {ρ : Wk k m} {ρ′} {E} {a} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
             ([a] : E ⊩⟨ l ⟩ a ∷ U.wk ρ (U.wk ρ′ F) / [F]′ [ρ] [ρ′] ⊢E)
           → E ⊩⟨ l ⟩ U.wk (lift (ρ • ρ′)) G [ a ]
      [G]′ {_} η η′ ⊢E [a] = [G] (η •ₜ η′) ⊢E ([a]′ η η′ ⊢E [a])
  in  Πᵣ′ (U.wk ρ F) (U.wk (lift ρ) G) (T.wkRed:*: [ρ] ⊢Δ D) ⊢ρF
           (T.wk (lift [ρ]) (⊢Δ ∙ ⊢ρF) ⊢G)
           (≅-wk [ρ] ⊢Δ A≡A)
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ → irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                    ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] → irrelevance′ (wk-comp-subst ρ₁ ρ G)
                                      ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a]))
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] [b] [a≡b] →
              let [a≡b]′ = irrelevanceEqTerm′ (wk-comp ρ₁ ρ F)
                                              ([F]′ [ρ₁] [ρ] ⊢Δ₁)
                                              ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁)
                                              [a≡b]
              in  irrelevanceEq″ (wk-comp-subst ρ₁ ρ G)
                                  (wk-comp-subst ρ₁ ρ G)
                                  ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a])
                                  (irrelevance′
                                            (wk-comp-subst ρ₁ ρ G)
                                            ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a]))
                                  (G-ext ([ρ₁] •ₜ [ρ]) ⊢Δ₁
                                         ([a]′ [ρ₁] [ρ] ⊢Δ₁ [a])
                                         ([a]′ [ρ₁] [ρ] ⊢Δ₁ [b])
                                         [a≡b]′))
wk {m = m} {ρ} {Γ} {Δ} {A} {l} [ρ] ⊢Δ (Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) =
  let ⊢ρF = T.wk [ρ] ⊢Δ ⊢F
      [F]′ : ∀ {k} {ρ : Wk k m} {ρ′ E} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
           → E ⊩⟨ l ⟩ U.wk ρ (U.wk ρ′ F)
      [F]′ {_} {ρ} {ρ′} [ρ] [ρ′] ⊢E = irrelevance′
                              (PE.sym (wk-comp ρ ρ′ F))
                              ([F] ([ρ] •ₜ [ρ′]) ⊢E)
      [a]′ : ∀ {k} {ρ : Wk k m} {ρ′ E a} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
             ([a] : E ⊩⟨ l ⟩ a ∷ U.wk ρ (U.wk ρ′ F) / [F]′ [ρ] [ρ′] ⊢E)
           → E ⊩⟨ l ⟩ a ∷ U.wk (ρ • ρ′) F / [F] ([ρ] •ₜ [ρ′]) ⊢E
      [a]′ {_} {ρ} {ρ′} [ρ] [ρ′] ⊢E [a] = irrelevanceTerm′ (wk-comp ρ ρ′ F)
                                          ([F]′ [ρ] [ρ′] ⊢E) ([F] ([ρ] •ₜ [ρ′]) ⊢E) [a]
      [G]′ : ∀ {k} {ρ : Wk k m} {ρ′ E a} ([ρ] : ρ ∷ E ⊆ Δ) ([ρ′] : ρ′ ∷ Δ ⊆ Γ) (⊢E : ⊢ E)
             ([a] : E ⊩⟨ l ⟩ a ∷ U.wk ρ (U.wk ρ′ F) / [F]′ [ρ] [ρ′] ⊢E)
           → E ⊩⟨ l ⟩ U.wk (lift (ρ • ρ′)) G [ a ]
      [G]′ {_} η η′ ⊢E [a] = [G] (η •ₜ η′) ⊢E ([a]′ η η′ ⊢E [a])
  in  Σᵣ′ (U.wk ρ F) (U.wk (lift ρ) G) (T.wkRed:*: [ρ] ⊢Δ D) ⊢ρF
           (T.wk (lift [ρ]) (⊢Δ ∙ ⊢ρF) ⊢G)
           (≅-wk [ρ] ⊢Δ A≡A)
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ → irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                    ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] → irrelevance′ (wk-comp-subst ρ₁ ρ G)
                                        ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a]))
           (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] [b] [a≡b] →
              let [a≡b]′ = irrelevanceEqTerm′ (wk-comp ρ₁ ρ F)
                                              ([F]′ [ρ₁] [ρ] ⊢Δ₁)
                                              ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁)
                                              [a≡b]
              in  irrelevanceEq″ (wk-comp-subst ρ₁ ρ G)
                                  (wk-comp-subst ρ₁ ρ G)
                                  ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a])
                                  (irrelevance′
                                            (wk-comp-subst ρ₁ ρ G)
                                            ([G]′ [ρ₁] [ρ] ⊢Δ₁ [a]))
                                  (G-ext ([ρ₁] •ₜ [ρ]) ⊢Δ₁
                                         ([a]′ [ρ₁] [ρ] ⊢Δ₁ [a])
                                         ([a]′ [ρ₁] [ρ] ⊢Δ₁ [b])
                                         [a≡b]′))
wk ρ ⊢Δ (emb 0<1 x) = emb 0<1 (wk ρ ⊢Δ x)

wkEq : ∀ {A B l} → ([ρ] : ρ ∷ Δ ⊆ Γ) (⊢Δ : ⊢ Δ)
       ([A] : Γ ⊩⟨ l ⟩ A)
     → Γ ⊩⟨ l ⟩ A ≡ B / [A]
     → Δ ⊩⟨ l ⟩ U.wk ρ A ≡ U.wk ρ B / wk [ρ] ⊢Δ [A]
wkEq ρ ⊢Δ (Uᵣ′ _ _ _) PE.refl = PE.refl
wkEq ρ ⊢Δ (ℕᵣ D) A≡B = wkRed* ρ ⊢Δ A≡B
wkEq ρ ⊢Δ (Emptyᵣ D) A≡B = wkRed* ρ ⊢Δ A≡B
wkEq ρ ⊢Δ (Unitᵣ D) A≡B = wkRed* ρ ⊢Δ A≡B
wkEq {ρ = ρ} [ρ] ⊢Δ (ne′ _ _ _ _) (ne₌ M D′ neM K≡M) =
  ne₌ (U.wk ρ M) (wkRed:*: [ρ] ⊢Δ D′)
      (wkNeutral ρ neM) (~-wk [ρ] ⊢Δ K≡M)
wkEq {ρ = ρ} [ρ] ⊢Δ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                (B₌ F′ G′ BΠ! D′ W≋W′ A≡B [F≡F′] [G≡G′]) =
  B₌ (U.wk ρ F′) (U.wk (lift ρ) G′) BΠ! (T.wkRed* [ρ] ⊢Δ D′) W≋W′ (≅-wk [ρ] ⊢Δ A≡B)
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ → irrelevanceEq″ (PE.sym (wk-comp ρ₁ ρ F))
                                 (PE.sym (wk-comp ρ₁ ρ F′))
                                 ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁)
                                 (irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                               ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
                                 ([F≡F′] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] →
        let [a]′ = irrelevanceTerm′ (wk-comp ρ₁ ρ F)
                                    (irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                                  ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
                                    ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁) [a]
        in  irrelevanceEq″ (wk-comp-subst ρ₁ ρ G)
                            (wk-comp-subst ρ₁ ρ G′)
                            ([G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′)
                            (irrelevance′ (wk-comp-subst ρ₁ ρ G)
                                          ([G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
                            ([G≡G′] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
wkEq {ρ = ρ} [ρ] ⊢Δ (Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                (B₌ F′ G′ BΣ! D′ W≋W′ A≡B [F≡F′] [G≡G′]) =
  B₌ (U.wk ρ F′) (U.wk (lift ρ) G′) BΣ! (T.wkRed* [ρ] ⊢Δ D′) W≋W′ (≅-wk [ρ] ⊢Δ A≡B)
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ → irrelevanceEq″ (PE.sym (wk-comp ρ₁ ρ F))
                                 (PE.sym (wk-comp ρ₁ ρ F′))
                                 ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁)
                                 (irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                               ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
                                 ([F≡F′] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] →
        let [a]′ = irrelevanceTerm′ (wk-comp ρ₁ ρ F)
                                    (irrelevance′ (PE.sym (wk-comp ρ₁ ρ F))
                                                  ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁))
                                    ([F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁) [a]
        in  irrelevanceEq″ (wk-comp-subst ρ₁ ρ G)
                            (wk-comp-subst ρ₁ ρ G′)
                            ([G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′)
                            (irrelevance′ (wk-comp-subst ρ₁ ρ G)
                                          ([G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
                            ([G≡G′] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
wkEq ρ ⊢Δ (emb 0<1 x) A≡B = wkEq ρ ⊢Δ x A≡B
-- Impossible cases
wkEq ρ ⊢Δ (Bᵣ BΣ! x) (B₌ F′ G′ BΠ! D′ () A≡B [F≡F′] [G≡G′])
wkEq ρ ⊢Δ (Bᵣ BΠ! x) (B₌ F′ G′ BΣ! D′ () A≡B [F≡F′] [G≡G′])

wkTerm : ∀ {A t l} ([ρ] : ρ ∷ Δ ⊆ Γ) (⊢Δ : ⊢ Δ)
         ([A] : Γ ⊩⟨ l ⟩ A)
       → Γ ⊩⟨ l ⟩ t ∷ A / [A]
       → Δ ⊩⟨ l ⟩ U.wk ρ t ∷ U.wk ρ A / wk [ρ] ⊢Δ [A]
wkTerm {ρ = ρ} [ρ] ⊢Δ (Uᵣ′ .⁰ 0<1 ⊢Γ) (Uₜ A d typeA A≡A [t]) =
  Uₜ (U.wk ρ A) (wkRed:*:Term [ρ] ⊢Δ d)
     (wkType ρ typeA) (≅ₜ-wk [ρ] ⊢Δ A≡A) (wk [ρ] ⊢Δ [t])
wkTerm ρ ⊢Δ (ℕᵣ D) [t] = wkTermℕ ρ ⊢Δ [t]
wkTerm ρ ⊢Δ (Emptyᵣ D) [t] = wkTermEmpty ρ ⊢Δ [t]
wkTerm ρ ⊢Δ (Unitᵣ D) [t] = wkTermUnit ρ ⊢Δ [t]
wkTerm {ρ = ρ} [ρ] ⊢Δ (ne′ K D neK K≡K) (neₜ k d nf) =
  neₜ (U.wk ρ k) (wkRed:*:Term [ρ] ⊢Δ d) (wkTermNe [ρ] ⊢Δ nf)
wkTerm {ρ = ρ} [ρ] ⊢Δ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) (Πₜ f d funcF f≡f [f] [f]₁) =
  Πₜ (U.wk ρ f) (wkRed:*:Term [ρ] ⊢Δ d) (wkFunction ρ funcF)
     (≅ₜ-wk [ρ] ⊢Δ f≡f)
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] [b] [a≡b] →
        let F-compEq = wk-comp ρ₁ ρ F
            G-compEq = wk-comp-subst ρ₁ ρ G
            [F]₁ = [F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁
            [F]₂ = irrelevance′ (PE.sym (wk-comp ρ₁ ρ F)) [F]₁
            [a]′ = irrelevanceTerm′ F-compEq [F]₂ [F]₁ [a]
            [b]′ = irrelevanceTerm′ F-compEq [F]₂ [F]₁ [b]
            [G]₁ = [G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′
            [G]₂ = irrelevance′ G-compEq [G]₁
            [a≡b]′ = irrelevanceEqTerm′ F-compEq [F]₂ [F]₁ [a≡b]
        in  irrelevanceEqTerm″
              (PE.cong (λ x → x ∘ _) (PE.sym (wk-comp ρ₁ ρ _)))
              (PE.cong (λ x → x ∘ _) (PE.sym (wk-comp ρ₁ ρ _)))
              G-compEq
              [G]₁ [G]₂
              ([f] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′ [b]′ [a≡b]′))
     (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] →
        let [F]₁ = [F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁
            [F]₂ = irrelevance′ (PE.sym (wk-comp ρ₁ ρ F)) [F]₁
            [a]′ = irrelevanceTerm′ (wk-comp ρ₁ ρ F) [F]₂ [F]₁ [a]
            [G]₁ = [G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′
            [G]₂ = irrelevance′ (wk-comp-subst ρ₁ ρ G) [G]₁
        in  irrelevanceTerm″ (wk-comp-subst ρ₁ ρ G)
              (PE.cong (λ x → x ∘ _) (PE.sym (wk-comp ρ₁ ρ _)))
              [G]₁ [G]₂ ([f]₁ ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
wkTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣᵣ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
       (Σₜ p d p≅p (prodₙ {t = p₁}) (PE.refl , [p₁] , [p₂] , PE.refl)) =
  let [ρF] = irrelevance′ (PE.sym (wk-comp id ρ F)) ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
      [ρp₁] = wkTerm [ρ] ⊢Δ ([F] id (wf ⊢F)) [p₁]
      [ρp₁]′ = (irrelevanceTerm′
                  (begin
                    U.wk ρ (U.wk id F)
                  ≡⟨ PE.cong (U.wk ρ) (wk-id F) ⟩
                    U.wk ρ F
                  ≡⟨ PE.sym (wk-id (U.wk ρ F)) ⟩
                    U.wk id (U.wk ρ F)
                  ∎)
                  (wk [ρ] ⊢Δ ([F] id (wf ⊢F)))
                  [ρF]
                  [ρp₁])
      [ρp₂] = wkTerm [ρ] ⊢Δ ([G] id (wf ⊢F) [p₁]) [p₂]
      [ρG]′ = (irrelevance′ (wk-comp-subst id ρ G)
       ([G] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F))
        (irrelevanceTerm′ (wk-comp id ρ F)
         [ρF]
         ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
         [ρp₁]′)))
      [ρp₂]′ = irrelevanceTerm′
                  (begin
                    U.wk ρ (U.wk (lift id) G [ p₁ ])
                  ≡⟨ PE.cong (λ x → U.wk ρ (x [ p₁ ])) (wk-lift-id G) ⟩
                    U.wk ρ (G [ p₁ ])
                  ≡⟨ wk-β G ⟩
                    (U.wk (lift ρ) G) [ U.wk ρ p₁ ]
                  ≡⟨ PE.cong (λ x → x [ U.wk ρ p₁ ]) (PE.sym (wk-lift-id (U.wk (lift ρ) G))) ⟩
                    (U.wk (lift id) (U.wk (lift ρ) G)) [ U.wk ρ p₁ ]
                  ∎)
                  (wk [ρ] ⊢Δ ([G] id (wf ⊢F) [p₁])) [ρG]′
                  [ρp₂]
  in  Σₜ (U.wk ρ p) (wkRed:*:Term [ρ] ⊢Δ d) (≅ₜ-wk [ρ] ⊢Δ p≅p)
        (wkProduct ρ prodₙ) (PE.refl , [ρp₁]′ , [ρp₂]′ , PE.refl)
wkTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣᵣ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
       (Σₜ p d p≅p (ne x) p~p) =
  Σₜ (U.wk ρ p) (wkRed:*:Term [ρ] ⊢Δ d) (≅ₜ-wk [ρ] ⊢Δ p≅p)
     (wkProduct ρ (ne x)) (~-wk [ρ] ⊢Δ p~p)
wkTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣₚ F G D ⊢F ⊢G A≡A [F] [G] G-ext) (Σₜ p d p≅p pProd ([fst] , [snd])) =
  let [ρF] = irrelevance′ (PE.sym (wk-comp id ρ F)) ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
      [ρfst] = wkTerm [ρ] ⊢Δ ([F] id (wf ⊢F)) [fst]
      [ρfst]′ = (irrelevanceTerm′
                  (begin
                    U.wk ρ (U.wk id F)
                  ≡⟨ PE.cong (U.wk ρ) (wk-id F) ⟩
                    U.wk ρ F
                  ≡⟨ PE.sym (wk-id (U.wk ρ F)) ⟩
                    U.wk id (U.wk ρ F)
                  ∎)
                  (wk [ρ] ⊢Δ ([F] id (wf ⊢F)))
                  [ρF]
                  [ρfst])
      [ρsnd] = wkTerm [ρ] ⊢Δ ([G] id (wf ⊢F) [fst]) [snd]
      [ρG]′ = (irrelevance′ (wk-comp-subst id ρ G)
       ([G] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F))
        (irrelevanceTerm′ (wk-comp id ρ F)
         [ρF]
         ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
         [ρfst]′)))
      [ρsnd]′ = irrelevanceTerm′
        (begin
           U.wk ρ (U.wk (lift id) G [ fst _ p ])                    ≡⟨ PE.cong (λ x → U.wk ρ (x [ fst _ p ])) (wk-lift-id G) ⟩
           U.wk ρ (G [ fst _ p ])                                   ≡⟨ wk-β G ⟩
           (U.wk (lift ρ) G) [ fst _ (U.wk ρ p) ]                   ≡⟨ PE.cong (λ x → x [ fst _ (U.wk ρ p) ])
                                                                         (PE.sym (wk-lift-id (U.wk (lift ρ) G))) ⟩
           (U.wk (lift id) (U.wk (lift ρ) G)) [ fst _ (U.wk ρ p) ]  ∎)
        (wk [ρ] ⊢Δ ([G] id (wf ⊢F) [fst])) [ρG]′
        [ρsnd]
  in  Σₜ (U.wk ρ p) (wkRed:*:Term [ρ] ⊢Δ d) (≅ₜ-wk [ρ] ⊢Δ p≅p)
         (wkProduct ρ pProd) ([ρfst]′ , [ρsnd]′)
wkTerm ρ ⊢Δ (emb 0<1 x) t = wkTerm ρ ⊢Δ x t

wkEqTerm : ∀ {A t u l} ([ρ] : ρ ∷ Δ ⊆ Γ) (⊢Δ : ⊢ Δ)
           ([A] : Γ ⊩⟨ l ⟩ A)
         → Γ ⊩⟨ l ⟩ t ≡ u ∷ A / [A]
         → Δ ⊩⟨ l ⟩ U.wk ρ t ≡ U.wk ρ u ∷ U.wk ρ A / wk [ρ] ⊢Δ [A]
wkEqTerm {ρ = ρ} [ρ] ⊢Δ (Uᵣ′ .⁰ 0<1 ⊢Γ) (Uₜ₌ A B d d′ typeA typeB A≡B [t] [u] [t≡u]) =
  Uₜ₌ (U.wk ρ A) (U.wk ρ B) (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
      (wkType ρ typeA) (wkType ρ typeB) (≅ₜ-wk [ρ] ⊢Δ A≡B)
      (wk [ρ] ⊢Δ [t]) (wk [ρ] ⊢Δ [u]) (wkEq [ρ] ⊢Δ [t] [t≡u])
wkEqTerm ρ ⊢Δ (ℕᵣ D) [t≡u] = wkEqTermℕ ρ ⊢Δ [t≡u]
wkEqTerm ρ ⊢Δ (Emptyᵣ D) [t≡u] = wkEqTermEmpty ρ ⊢Δ [t≡u]
wkEqTerm ρ ⊢Δ (Unitᵣ D) [t≡u] = wkEqTermUnit ρ ⊢Δ [t≡u]
wkEqTerm {ρ  = ρ} [ρ] ⊢Δ (ne′ K D neK K≡K) (neₜ₌ k m d d′ nf) =
  neₜ₌ (U.wk ρ k) (U.wk ρ m)
       (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
       (wkEqTermNe [ρ] ⊢Δ nf)
wkEqTerm {ρ  = ρ} [ρ] ⊢Δ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                    (Πₜ₌ f g d d′ funcF funcG f≡g [t] [u] [f≡g]) =
  let [A] = Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext
  in  Πₜ₌ (U.wk ρ f) (U.wk ρ g) (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
          (wkFunction ρ funcF) (wkFunction ρ funcG)
          (≅ₜ-wk [ρ] ⊢Δ f≡g) (wkTerm [ρ] ⊢Δ [A] [t]) (wkTerm [ρ] ⊢Δ [A] [u])
          (λ {_} {ρ₁} [ρ₁] ⊢Δ₁ [a] →
             let [F]₁ = [F] ([ρ₁] •ₜ [ρ]) ⊢Δ₁
                 [F]₂ = irrelevance′ (PE.sym (wk-comp ρ₁ ρ F)) [F]₁
                 [a]′ = irrelevanceTerm′ (wk-comp ρ₁ ρ F) [F]₂ [F]₁ [a]
                 [G]₁ = [G] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′
                 [G]₂ = irrelevance′ (wk-comp-subst ρ₁ ρ G) [G]₁
             in  irrelevanceEqTerm″ (PE.cong (λ y → y ∘ _) (PE.sym (wk-comp ρ₁ ρ _)))
                                    (PE.cong (λ y → y ∘ _) (PE.sym (wk-comp ρ₁ ρ _)))
                                    (wk-comp-subst ρ₁ ρ G)
                                    [G]₁ [G]₂
                                    ([f≡g] ([ρ₁] •ₜ [ρ]) ⊢Δ₁ [a]′))
wkEqTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣᵣ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
         (Σₜ₌ p r d d′ (prodₙ {t = p₁}) prodₙ p≅r [t] [u]
            (PE.refl , PE.refl ,
             [p₁] , [r₁] , [p₂] , [r₂] , [fst≡] , [snd≡])) =
  let [A] = Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext
      ⊢Γ = wf ⊢F
      ρidF≡idρF = begin
                    U.wk ρ (U.wk id F)
                  ≡⟨ PE.cong (U.wk ρ) (wk-id F) ⟩
                    U.wk ρ F
                  ≡⟨ PE.sym (wk-id (U.wk ρ F)) ⟩
                    U.wk id (U.wk ρ F)
                  ∎
      [ρF] = irrelevance′ (PE.sym (wk-comp id ρ F)) ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
      [ρp₁] = wkTerm [ρ] ⊢Δ ([F] id ⊢Γ) [p₁]
      [ρp₁]′ = irrelevanceTerm′
                  ρidF≡idρF
                  (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                  [ρp₁]
      [ρr₁] = wkTerm [ρ] ⊢Δ ([F] id ⊢Γ) [r₁]
      [ρr₁]′ = irrelevanceTerm′
                  ρidF≡idρF
                  (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                  [ρr₁]
      [ρfst≡] = wkEqTerm [ρ] ⊢Δ ([F] id ⊢Γ) [fst≡]
      [ρfst≡]′ = irrelevanceEqTerm′
                   ρidF≡idρF
                   (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                   [ρfst≡]
      [ρsnd≡] = wkEqTerm [ρ] ⊢Δ ([G] id ⊢Γ [p₁]) [snd≡]
      [ρG]′ = (irrelevance′ (wk-comp-subst id ρ G)
       ([G] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F))
        (irrelevanceTerm′ (wk-comp id ρ F)
         [ρF]
         ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
         [ρp₁]′)))
      [ρG]″ = (irrelevance′ (wk-comp-subst id ρ G)
         ([G] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F))
         (irrelevanceTerm′ (wk-comp id ρ F)
           [ρF]
           ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
           [ρr₁]′)))
      ρG-eq = λ t → (begin
                    U.wk ρ (U.wk (lift id) G [ t ])
                  ≡⟨ PE.cong (λ x → U.wk ρ (x [ t ])) (wk-lift-id G) ⟩
                    U.wk ρ (G [ t ])
                  ≡⟨ wk-β G ⟩
                    (U.wk (lift ρ) G) [ U.wk ρ t ]
                  ≡⟨ PE.cong (λ x → x [ U.wk ρ t ]) (PE.sym (wk-lift-id (U.wk (lift ρ) G))) ⟩
                    (U.wk (lift id) (U.wk (lift ρ) G)) [ U.wk ρ t ]
                  ∎)
      [ρp₂] = wkTerm [ρ] ⊢Δ ([G] id ⊢Γ [p₁]) [p₂]
      [ρp₂]′ = irrelevanceTerm′ (ρG-eq p₁) (wk [ρ] ⊢Δ ([G] id ⊢Γ [p₁])) [ρG]′ [ρp₂]
      [ρr₂] = wkTerm [ρ] ⊢Δ ([G] id ⊢Γ [r₁]) [r₂]
      [ρr₂]′ = irrelevanceTerm′ (ρG-eq _) (wk [ρ] ⊢Δ ([G] id ⊢Γ [r₁])) [ρG]″ [ρr₂]
      [ρsnd≡]′ = irrelevanceEqTerm′
                  (ρG-eq p₁)
                  (wk [ρ] ⊢Δ ([G] id (wf ⊢F) [p₁])) [ρG]′
                  [ρsnd≡]
  in  Σₜ₌ (U.wk ρ p) (U.wk ρ r) (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
          (wkProduct ρ prodₙ) (wkProduct ρ prodₙ)
          (≅ₜ-wk [ρ] ⊢Δ p≅r) (wkTerm [ρ] ⊢Δ [A] [t]) (wkTerm [ρ] ⊢Δ [A] [u])
          (PE.refl , PE.refl ,
           [ρp₁]′ , [ρr₁]′ , [ρp₂]′ , [ρr₂]′ , [ρfst≡]′ , [ρsnd≡]′)
wkEqTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣᵣ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
         (Σₜ₌ p r d d′ (ne x) (ne y) p≅r [t] [u] p~r) =
  let [A] = Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext
  in  Σₜ₌ (U.wk ρ p) (U.wk ρ r) (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
          (wkProduct ρ (ne x)) (wkProduct ρ (ne y))
          (≅ₜ-wk [ρ] ⊢Δ p≅r) (wkTerm [ρ] ⊢Δ [A] [t]) (wkTerm [ρ] ⊢Δ [A] [u])
          (~-wk [ρ] ⊢Δ p~r)
wkEqTerm {ρ = ρ} [ρ] ⊢Δ [A]@(Bᵣ′ BΣₚ F G D ⊢F ⊢G A≡A [F] [G] G-ext)
         (Σₜ₌ p r d d′ pProd rProd p≅r [t] [u] ([fstp] , [fstr] , [fst≡] , [snd≡])) =
  let [A] = Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext
      ⊢Γ = wf ⊢F
      ρidF≡idρF = begin
                    U.wk ρ (U.wk id F)
                  ≡⟨ PE.cong (U.wk ρ) (wk-id F) ⟩
                    U.wk ρ F
                  ≡⟨ PE.sym (wk-id (U.wk ρ F)) ⟩
                    U.wk id (U.wk ρ F)
                  ∎
      [ρF] = irrelevance′ (PE.sym (wk-comp id ρ F)) ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
      [ρfstp] = wkTerm [ρ] ⊢Δ ([F] id ⊢Γ) [fstp]
      [ρfstp]′ = irrelevanceTerm′
                  ρidF≡idρF
                  (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                  [ρfstp]
      [ρfstr] = wkTerm [ρ] ⊢Δ ([F] id ⊢Γ) [fstr]
      [ρfstr]′ = irrelevanceTerm′
                  ρidF≡idρF
                  (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                  [ρfstr]
      [ρfst≡] = wkEqTerm [ρ] ⊢Δ ([F] id ⊢Γ) [fst≡]
      [ρfst≡]′ = irrelevanceEqTerm′
                   ρidF≡idρF
                   (wk [ρ] ⊢Δ ([F] id ⊢Γ)) [ρF]
                   [ρfst≡]
      [ρsnd≡] = wkEqTerm [ρ] ⊢Δ ([G] id ⊢Γ [fstp]) [snd≡]
      [ρG]′ = (irrelevance′ (wk-comp-subst id ρ G)
       ([G] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F))
        (irrelevanceTerm′ (wk-comp id ρ F)
         [ρF]
         ([F] [ρ] (wf (T.wk [ρ] ⊢Δ ⊢F)))
         [ρfstp]′)))
      [ρsnd≡]′ = irrelevanceEqTerm′
        (begin
           U.wk ρ (U.wk (lift id) G [ fst _ p ])                    ≡⟨ PE.cong (λ x → U.wk ρ (x [ fst _ p ])) (wk-lift-id G) ⟩
           U.wk ρ (G [ fst _ p ])                                   ≡⟨ wk-β G ⟩
           (U.wk (lift ρ) G) [ fst _ (U.wk ρ p) ]                   ≡⟨ PE.cong (λ x → x [ fst _ (U.wk ρ p) ])
                                                                         (PE.sym (wk-lift-id (U.wk (lift ρ) G))) ⟩
           (U.wk (lift id) (U.wk (lift ρ) G)) [ fst _ (U.wk ρ p) ]  ∎)
        (wk [ρ] ⊢Δ ([G] id (wf ⊢F) [fstp])) [ρG]′
        [ρsnd≡]
  in  Σₜ₌ (U.wk ρ p) (U.wk ρ r) (wkRed:*:Term [ρ] ⊢Δ d) (wkRed:*:Term [ρ] ⊢Δ d′)
          (wkProduct ρ pProd) (wkProduct ρ rProd)
          (≅ₜ-wk [ρ] ⊢Δ p≅r) (wkTerm [ρ] ⊢Δ [A] [t]) (wkTerm [ρ] ⊢Δ [A] [u])
          ([ρfstp]′ , [ρfstr]′ , [ρfst≡]′ , [ρsnd≡]′)
wkEqTerm ρ ⊢Δ (emb 0<1 x) t≡u = wkEqTerm ρ ⊢Δ x t≡u
-- Impossible cases
wkEqTerm ρ ⊢Δ (Bᵣ BΣᵣ x) (Σₜ₌ p r d d′ prodₙ (ne y) p≅r [t] [u] ())
wkEqTerm ρ ⊢Δ (Bᵣ BΣᵣ x) (Σₜ₌ p r d d′ (ne y) prodₙ p≅r [t] [u] ())
