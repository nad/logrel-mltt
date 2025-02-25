module Definition.Typed.Properties {ℓ} (M : Set ℓ) where

open import Definition.Untyped M hiding (_∷_)
open import Definition.Typed M

open import Tools.Empty using (⊥; ⊥-elim)
open import Tools.Nat
open import Tools.Product
open import Tools.PropositionalEquality as PE
  using (≈-refl; ≈-sym; ≈-trans)

private
  variable
    n : Nat
    Γ : Con Term n
    A A′ B B′ C U′ : Term n
    a b t u u′ : Term n

-- Escape context extraction

wfTerm : Γ ⊢ t ∷ A → ⊢ Γ
wfTerm (ℕⱼ ⊢Γ) = ⊢Γ
wfTerm (Emptyⱼ ⊢Γ) = ⊢Γ
wfTerm (Unitⱼ ⊢Γ) = ⊢Γ
wfTerm (ΠΣⱼ F ▹ G) = wfTerm F
wfTerm (var ⊢Γ x₁) = ⊢Γ
wfTerm (lamⱼ F t) with wfTerm t
wfTerm (lamⱼ F t) | ⊢Γ ∙ F′ = ⊢Γ
wfTerm (g ∘ⱼ a) = wfTerm a
wfTerm (zeroⱼ ⊢Γ) = ⊢Γ
wfTerm (sucⱼ n) = wfTerm n
wfTerm (natrecⱼ F z s n) = wfTerm z
wfTerm (prodrecⱼ F G A t u) = wfTerm t
wfTerm (Emptyrecⱼ A e) = wfTerm e
wfTerm (starⱼ ⊢Γ) = ⊢Γ
wfTerm (conv t A≡B) = wfTerm t
wfTerm (prodⱼ F G a a₁) = wfTerm a
wfTerm (fstⱼ _ _ a) = wfTerm a
wfTerm (sndⱼ _ _ a) = wfTerm a

wf : Γ ⊢ A → ⊢ Γ
wf (ℕⱼ ⊢Γ) = ⊢Γ
wf (Emptyⱼ ⊢Γ) = ⊢Γ
wf (Unitⱼ ⊢Γ) = ⊢Γ
wf (Uⱼ ⊢Γ) = ⊢Γ
wf (ΠΣⱼ F ▹ G) = wf F
wf (univ A) = wfTerm A

wfEqTerm : Γ ⊢ t ≡ u ∷ A → ⊢ Γ
wfEqTerm (refl t) = wfTerm t
wfEqTerm (sym t≡u) = wfEqTerm t≡u
wfEqTerm (trans t≡u u≡r) = wfEqTerm t≡u
wfEqTerm (conv t≡u A≡B) = wfEqTerm t≡u
wfEqTerm (ΠΣ-cong F F≡H G≡E) = wfEqTerm F≡H
wfEqTerm (app-cong f≡g a≡b p≈p₁ p≈p₂) = wfEqTerm f≡g
wfEqTerm (β-red F G t a p≡q) = wfTerm a
wfEqTerm (η-eq F f g f0≡g0) = wfTerm f
wfEqTerm (suc-cong n) = wfEqTerm n
wfEqTerm (natrec-cong _ F≡F′ z≡z′ s≡s′ n≡n′ _ _ _) = wfEqTerm z≡z′
wfEqTerm (natrec-zero F z s) = wfTerm z
wfEqTerm (natrec-suc n F z s) = wfTerm n
wfEqTerm (Emptyrec-cong A≡A' e≡e' _) = wfEqTerm e≡e'
wfEqTerm (η-unit e e') = wfTerm e
wfEqTerm (prod-cong F _ _ _) = wf F
wfEqTerm (fst-cong _ _ a) = wfEqTerm a
wfEqTerm (snd-cong _ _ a) = wfEqTerm a
wfEqTerm (prodrec-cong F _ _ _ _ _) = wf F
wfEqTerm (prodrec-β F _ _ _ _ _ _) = wf F
wfEqTerm (Σ-η _ _ x _ _ _) = wfTerm x
wfEqTerm (Σ-β₁ _ _ x _ _ _) = wfTerm x
wfEqTerm (Σ-β₂ _ _ x _ _ _) = wfTerm x

wfEq : Γ ⊢ A ≡ B → ⊢ Γ
wfEq (univ A≡B) = wfEqTerm A≡B
wfEq (refl A) = wf A
wfEq (sym A≡B) = wfEq A≡B
wfEq (trans A≡B B≡C) = wfEq A≡B
wfEq (ΠΣ-cong F F≡H G≡E) = wf F


-- Reduction is a subset of conversion

subsetTerm : Γ ⊢ t ⇒ u ∷ A → Γ ⊢ t ≡ u ∷ A
subsetTerm (natrec-subst F z s n⇒n′) =
  natrec-cong F (refl F) (refl z) (refl s) (subsetTerm n⇒n′) ≈-refl ≈-refl ≈-refl
subsetTerm (natrec-zero F z s) = natrec-zero F z s
subsetTerm (natrec-suc n F z s) = natrec-suc n F z s
subsetTerm (Emptyrec-subst A n⇒n′) =
  Emptyrec-cong (refl A) (subsetTerm n⇒n′) ≈-refl
subsetTerm (app-subst t⇒u a) =
  app-cong (subsetTerm t⇒u) (refl a) PE.refl PE.refl
subsetTerm (β-red A B t a p≈p′) = β-red A B t a p≈p′
subsetTerm (conv t⇒u A≡B) = conv (subsetTerm t⇒u) A≡B
subsetTerm (fst-subst F G x) = fst-cong F G (subsetTerm x)
subsetTerm (snd-subst F G x) = snd-cong F G (subsetTerm x)
subsetTerm (prodrec-subst F G A u t⇒t′) =
  prodrec-cong F G (refl A) (subsetTerm t⇒t′) (refl u) PE.refl
subsetTerm (prodrec-β F G A t t′ u eq) = prodrec-β F G A t t′ u eq
subsetTerm (Σ-β₁ F G x x₁ x₂ x₃) = Σ-β₁ F G x x₁ x₂ x₃
subsetTerm (Σ-β₂ F G x x₁ x₂ x₃) = Σ-β₂ F G x x₁ x₂ x₃

subset : Γ ⊢ A ⇒ B → Γ ⊢ A ≡ B
subset (univ A⇒B) = univ (subsetTerm A⇒B)

subset*Term : Γ ⊢ t ⇒* u ∷ A → Γ ⊢ t ≡ u ∷ A
subset*Term (id t) = refl t
subset*Term (t⇒t′ ⇨ t⇒*u) = trans (subsetTerm t⇒t′) (subset*Term t⇒*u)

subset* : Γ ⊢ A ⇒* B → Γ ⊢ A ≡ B
subset* (id A) = refl A
subset* (A⇒A′ ⇨ A′⇒*B) = trans (subset A⇒A′) (subset* A′⇒*B)


-- Can extract left-part of a reduction

redFirstTerm :{Γ : Con Term n} → Γ ⊢ t ⇒ u ∷ A → Γ ⊢ t ∷ A
redFirstTerm (conv t⇒u A≡B) = conv (redFirstTerm t⇒u) A≡B
redFirstTerm (app-subst t⇒u a) = (redFirstTerm t⇒u) ∘ⱼ a
redFirstTerm (β-red {p} A B t a PE.refl) =
  _∘ⱼ_ {q = p} (conv (lamⱼ A t) (ΠΣ-cong A (refl A) (refl B))) a
redFirstTerm (natrec-subst F z s n⇒n′) = natrecⱼ F z s (redFirstTerm n⇒n′)
redFirstTerm (natrec-zero F z s) = natrecⱼ F z s (zeroⱼ (wfTerm z))
redFirstTerm (natrec-suc n F z s) = natrecⱼ F z s (sucⱼ n)
redFirstTerm (Emptyrec-subst A n⇒n′) = Emptyrecⱼ A (redFirstTerm n⇒n′)
redFirstTerm (fst-subst F G x) = fstⱼ F G (redFirstTerm x)
redFirstTerm (snd-subst F G x) = sndⱼ F G (redFirstTerm x)
redFirstTerm (prodrec-subst F G A u t⇒t′) = prodrecⱼ F G A (redFirstTerm t⇒t′) u
redFirstTerm (prodrec-β F G A t t′ u PE.refl) =
  prodrecⱼ F G A
    (conv (prodⱼ F G t t′) (ΠΣ-cong F (refl F) (refl G)))
    u
redFirstTerm (Σ-β₁ {q = q} F G x x₁ x₂ PE.refl) =
  fstⱼ {q = q} F G
    (conv (prodⱼ F G x x₁) (ΠΣ-cong F (refl F) (refl G)))
redFirstTerm (Σ-β₂ {q = q} F G x x₁ x₂ PE.refl) =
  sndⱼ {q = q} F G
    (conv (prodⱼ F G x x₁) (ΠΣ-cong F (refl F) (refl G)))

redFirst :{Γ : Con Term n} → Γ ⊢ A ⇒ B → Γ ⊢ A
redFirst (univ A⇒B) = univ (redFirstTerm A⇒B)

redFirst*Term : {Γ : Con Term n} → Γ ⊢ t ⇒* u ∷ A → Γ ⊢ t ∷ A
redFirst*Term (id t) = t
redFirst*Term (t⇒t′ ⇨ t′⇒*u) = redFirstTerm t⇒t′

redFirst* : {Γ : Con Term n} → Γ ⊢ A ⇒* B → Γ ⊢ A
redFirst* (id A) = A
redFirst* (A⇒A′ ⇨ A′⇒*B) = redFirst A⇒A′

-- No neutral terms are well-formed in an empty context

noNe : ε ⊢ t ∷ A → Neutral t → ⊥
noNe (conv ⊢t x) n = noNe ⊢t n
noNe (var x₁ ()) (var x)
noNe (⊢t ∘ⱼ ⊢t₁) (∘ₙ neT) = noNe ⊢t neT
noNe (fstⱼ _ _ ⊢t) (fstₙ neT) = noNe ⊢t neT
noNe (sndⱼ _ _ ⊢t) (sndₙ neT) = noNe ⊢t neT
noNe (natrecⱼ x ⊢t ⊢t₁ ⊢t₂) (natrecₙ neT) = noNe ⊢t₂ neT
noNe (prodrecⱼ x x₁ x₂ ⊢t ⊢t₁) (prodrecₙ neT) = noNe ⊢t neT
noNe (Emptyrecⱼ A ⊢e) (Emptyrecₙ neT) = noNe ⊢e neT

-- Neutrals do not weak head reduce

neRedTerm : (d : Γ ⊢ t ⇒ u ∷ A) (n : Neutral t) → ⊥
neRedTerm (conv d x) n = neRedTerm d n
neRedTerm (app-subst d x) (∘ₙ n) = neRedTerm d n
neRedTerm (β-red x _ x₁ x₂ _) (∘ₙ ())
neRedTerm (natrec-subst x x₁ x₂ d) (natrecₙ n₁) = neRedTerm d n₁
neRedTerm (natrec-zero x x₁ x₂) (natrecₙ ())
neRedTerm (natrec-suc x x₁ x₂ x₃) (natrecₙ ())
neRedTerm (Emptyrec-subst x d) (Emptyrecₙ n₁) = neRedTerm d n₁
neRedTerm (fst-subst _ _ d) (fstₙ n) = neRedTerm d n
neRedTerm (snd-subst _ _ d) (sndₙ n) = neRedTerm d n
neRedTerm (prodrec-subst x x₁ x₂ x₃ d) (prodrecₙ n) = neRedTerm d n
neRedTerm (prodrec-β _ _ _ _ _ _ _) (prodrecₙ ())
neRedTerm (Σ-β₁ _ _ _ _ _ _) (fstₙ ())
neRedTerm (Σ-β₂ _ _ _ _ _ _) (sndₙ ())

neRed : (d : Γ ⊢ A ⇒ B) (N : Neutral A) → ⊥
neRed (univ x) N = neRedTerm x N

-- Whnfs do not weak head reduce

whnfRedTerm : (d : Γ ⊢ t ⇒ u ∷ A) (w : Whnf t) → ⊥
whnfRedTerm (conv d x) w = whnfRedTerm d w
whnfRedTerm (app-subst d x) (ne (∘ₙ x₁)) = neRedTerm d x₁
whnfRedTerm (β-red x _ x₁ x₂ _) (ne (∘ₙ ()))
whnfRedTerm (natrec-subst x x₁ x₂ d) (ne (natrecₙ x₃)) = neRedTerm d x₃
whnfRedTerm (natrec-zero x x₁ x₂) (ne (natrecₙ ()))
whnfRedTerm (natrec-suc x x₁ x₂ x₃) (ne (natrecₙ ()))
whnfRedTerm (Emptyrec-subst x d) (ne (Emptyrecₙ x₂)) = neRedTerm d x₂
whnfRedTerm (fst-subst _ _ d) (ne (fstₙ n)) = neRedTerm d n
whnfRedTerm (snd-subst _ _ d) (ne (sndₙ n)) = neRedTerm d n
whnfRedTerm (prodrec-subst x x₁ x₂ x₃ d) (ne (prodrecₙ n)) = neRedTerm d n
whnfRedTerm (prodrec-β _ _ _ _ _ _ _) (ne (prodrecₙ ()))
whnfRedTerm (Σ-β₁ _ _ _ _ _ _) (ne (fstₙ ()))
whnfRedTerm (Σ-β₂ _ _ _ _ _ _) (ne (sndₙ ()))

whnfRed : (d : Γ ⊢ A ⇒ B) (w : Whnf A) → ⊥
whnfRed (univ x) w = whnfRedTerm x w

whnfRed*Term : (d : Γ ⊢ t ⇒* u ∷ A) (w : Whnf t) → t PE.≡ u
whnfRed*Term (id x) Uₙ = PE.refl
whnfRed*Term (id x) ΠΣₙ = PE.refl
whnfRed*Term (id x) ℕₙ = PE.refl
whnfRed*Term (id x) Emptyₙ = PE.refl
whnfRed*Term (id x) Unitₙ = PE.refl
whnfRed*Term (id x) lamₙ = PE.refl
whnfRed*Term (id x) prodₙ = PE.refl
whnfRed*Term (id x) zeroₙ = PE.refl
whnfRed*Term (id x) sucₙ = PE.refl
whnfRed*Term (id x) starₙ = PE.refl
whnfRed*Term (id x) (ne x₁) = PE.refl
whnfRed*Term (conv x x₁ ⇨ d) w = ⊥-elim (whnfRedTerm x w)
whnfRed*Term (x ⇨ d) (ne x₁) = ⊥-elim (neRedTerm x x₁)

whnfRed* : (d : Γ ⊢ A ⇒* B) (w : Whnf A) → A PE.≡ B
whnfRed* (id x) w = PE.refl
whnfRed* (x ⇨ d) w = ⊥-elim (whnfRed x w)

-- Whr is deterministic

whrDetTerm : (d : Γ ⊢ t ⇒ u ∷ A) (d′ : Γ ⊢ t ⇒ u′ ∷ A′) → u PE.≡ u′
whrDetTerm (conv d x) d′ = whrDetTerm d d′
whrDetTerm d (conv d′ x₁) = whrDetTerm d d′
whrDetTerm (app-subst d x) (app-subst d′ x₁) rewrite whrDetTerm d d′ = PE.refl
whrDetTerm (β-red x _ x₁ x₂ p≡q) (β-red x₃ _ x₄ x₅ p≡q₁) = PE.refl
whrDetTerm (fst-subst _ _ x) (fst-subst _ _ y) rewrite whrDetTerm x y = PE.refl
whrDetTerm (snd-subst _ _ x) (snd-subst _ _ y) rewrite whrDetTerm x y = PE.refl
whrDetTerm (Σ-β₁ _ _ _ _ _ _) (Σ-β₁ _ _ _ _ _ _) = PE.refl
whrDetTerm (Σ-β₂ _ _ _ _ _ _) (Σ-β₂ _ _ _ _ _ _) = PE.refl
whrDetTerm (natrec-subst x x₁ x₂ d) (natrec-subst x₃ x₄ x₅ d′) rewrite whrDetTerm d d′ = PE.refl
whrDetTerm (natrec-zero x x₁ x₂) (natrec-zero x₃ x₄ x₅) = PE.refl
whrDetTerm (natrec-suc x x₁ x₂ x₃) (natrec-suc x₄ x₅ x₆ x₇) = PE.refl
whrDetTerm (prodrec-subst x x₁ x₂ x₃ d) (prodrec-subst x₅ x₆ x₇ x₈ d′)
  rewrite whrDetTerm d d′ = PE.refl
whrDetTerm (prodrec-β _ _ _ _ _ _ _) (prodrec-β _ _ _ _ _ _ _) = PE.refl
whrDetTerm (Emptyrec-subst x d) (Emptyrec-subst x₂ d′) rewrite whrDetTerm d d′ = PE.refl

whrDetTerm (app-subst d x) (β-red x₁ _ x₂ x₃ p≡q) = ⊥-elim (whnfRedTerm d lamₙ)
whrDetTerm (β-red x _ x₁ x₂ p≡q) (app-subst d x₃) = ⊥-elim (whnfRedTerm d lamₙ)
whrDetTerm (natrec-subst x x₁ x₂ d) (natrec-zero x₃ x₄ x₅) = ⊥-elim (whnfRedTerm d zeroₙ)
whrDetTerm (natrec-subst x x₁ x₂ d) (natrec-suc x₃ x₄ x₅ x₆) = ⊥-elim (whnfRedTerm d sucₙ)
whrDetTerm (natrec-zero x x₁ x₂) (natrec-subst x₃ x₄ x₅ d′) = ⊥-elim (whnfRedTerm d′ zeroₙ)
whrDetTerm (natrec-suc x x₁ x₂ x₃) (natrec-subst x₄ x₅ x₆ d′) = ⊥-elim (whnfRedTerm d′ sucₙ)
whrDetTerm (fst-subst _ _ x) (Σ-β₁ F G x₁ x₂ x₃ _) =
  ⊥-elim (whnfRedTerm x prodₙ)
whrDetTerm (snd-subst _ _ x) (Σ-β₂ F G x₁ x₂ x₃ _) =
  ⊥-elim (whnfRedTerm x prodₙ)
whrDetTerm (Σ-β₁ F G x x₁ x₂ _) (fst-subst _ _ y) = ⊥-elim (whnfRedTerm y prodₙ)
whrDetTerm (Σ-β₂ F G x x₁ x₂ _) (snd-subst _ _ y) = ⊥-elim (whnfRedTerm y prodₙ)
whrDetTerm
  (prodrec-subst x x₁ x₂ x₃ x₄)
  (prodrec-β x₅ x₆ x₇ x₈ x₉ x₁₀ _) =
  ⊥-elim (whnfRedTerm x₄ prodₙ)
whrDetTerm (prodrec-β x x₁ x₂ x₃ x₄ x₅ _) (prodrec-subst x₆ x₇ x₈ x₉ y) =
  ⊥-elim (whnfRedTerm y prodₙ)

whrDet : (d : Γ ⊢ A ⇒ B) (d′ : Γ ⊢ A ⇒ B′) → B PE.≡ B′
whrDet (univ x) (univ x₁) = whrDetTerm x x₁

whrDet↘Term : (d : Γ ⊢ t ↘ u ∷ A) (d′ : Γ ⊢ t ⇒* u′ ∷ A) → Γ ⊢ u′ ⇒* u ∷ A
whrDet↘Term (proj₁ , proj₂) (id x) = proj₁
whrDet↘Term (id x , proj₂) (x₁ ⇨ d′) = ⊥-elim (whnfRedTerm x₁ proj₂)
whrDet↘Term (x ⇨ proj₁ , proj₂) (x₁ ⇨ d′) =
  whrDet↘Term (PE.subst (λ x₂ → _ ⊢ x₂ ↘ _ ∷ _) (whrDetTerm x x₁) (proj₁ , proj₂)) d′

whrDet*Term : (d : Γ ⊢ t ↘ u ∷ A) (d′ : Γ ⊢ t ↘ u′ ∷ A) → u PE.≡ u′
whrDet*Term (id x , proj₂) (id x₁ , proj₄) = PE.refl
whrDet*Term (id x , proj₂) (x₁ ⇨ proj₃ , proj₄) = ⊥-elim (whnfRedTerm x₁ proj₂)
whrDet*Term (x ⇨ proj₁ , proj₂) (id x₁ , proj₄) = ⊥-elim (whnfRedTerm x proj₄)
whrDet*Term (x ⇨ proj₁ , proj₂) (x₁ ⇨ proj₃ , proj₄) =
  whrDet*Term (proj₁ , proj₂) (PE.subst (λ x₂ → _ ⊢ x₂ ↘ _ ∷ _)
                                    (whrDetTerm x₁ x) (proj₃ , proj₄))

whrDet* : (d : Γ ⊢ A ↘ B) (d′ : Γ ⊢ A ↘ B′) → B PE.≡ B′
whrDet* (id x , proj₂) (id x₁ , proj₄) = PE.refl
whrDet* (id x , proj₂) (x₁ ⇨ proj₃ , proj₄) = ⊥-elim (whnfRed x₁ proj₂)
whrDet* (x ⇨ proj₁ , proj₂) (id x₁ , proj₄) = ⊥-elim (whnfRed x proj₄)
whrDet* (A⇒A′ ⇨ A′⇒*B , whnfB) (A⇒A″ ⇨ A″⇒*B′ , whnfB′) =
  whrDet* (A′⇒*B , whnfB) (PE.subst (λ x → _ ⊢ x ↘ _)
                                     (whrDet A⇒A″ A⇒A′)
                                     (A″⇒*B′ , whnfB′))

-- Identity of syntactic reduction

idRed:*: : Γ ⊢ A → Γ ⊢ A :⇒*: A
idRed:*: A = [ A , A , id A ]

idRedTerm:*: : Γ ⊢ t ∷ A → Γ ⊢ t :⇒*: t ∷ A
idRedTerm:*: t = [ t , t , id t ]

-- U cannot be a term

UnotInA : Γ ⊢ U ∷ A → ⊥
UnotInA (conv U∷U x) = UnotInA U∷U

UnotInA[t] : t [ a ] PE.≡ U
         → Γ ⊢ a ∷ A
         → Γ ∙ A ⊢ t ∷ B
         → ⊥
UnotInA[t] () x₁ (ℕⱼ x₂)
UnotInA[t] () x₁ (Emptyⱼ x₂)
UnotInA[t] () _  (ΠΣⱼ _ ▹ _)
UnotInA[t] x₁ x₂ (var x₃ here) rewrite x₁ = UnotInA x₂
UnotInA[t] () x₂ (var x₃ (there x₄))
UnotInA[t] () x₁ (lamⱼ x₂ x₃)
UnotInA[t] () x₁ (x₂ ∘ⱼ x₃)
UnotInA[t] () x₁ (zeroⱼ x₂)
UnotInA[t] () x₁ (sucⱼ x₂)
UnotInA[t] () x₁ (natrecⱼ x₂ x₃ x₄ x₅)
UnotInA[t] () x₁ (Emptyrecⱼ x₂ x₃)
UnotInA[t] x x₁ (conv x₂ x₃) = UnotInA[t] x x₁ x₂

UnotInA[t,u] : subst (consSubst (consSubst idSubst u) u′) t PE.≡ U
              → Γ ⊢ u ∷ A
              → Γ ⊢ u′ ∷ B [ a ]
              → Γ ∙ A ∙ B ⊢ t ∷ C
              → ⊥
UnotInA[t,u] PE.refl u u′ (var x here) = UnotInA u′
UnotInA[t,u] PE.refl u u′ (var x (there here)) = UnotInA u
UnotInA[t,u] eq u u′ (conv t x) = UnotInA[t,u] eq u u′ t

redU*Term′ : U′ PE.≡ U → Γ ⊢ A ⇒ U′ ∷ B → ⊥
redU*Term′ U′≡U (conv A⇒U x) = redU*Term′ U′≡U A⇒U
redU*Term′ () (app-subst A⇒U x)
redU*Term′ U′≡U (β-red x _ x₁ x₂ p≡q) = UnotInA[t] U′≡U x₂ x₁
redU*Term′ () (natrec-subst x x₁ x₂ A⇒U)
redU*Term′ PE.refl (natrec-zero x x₁ x₂) = UnotInA x₁
redU*Term′ U′≡U (natrec-suc x x₁ x₂ x₃) = UnotInA[t,u] U′≡U x (natrecⱼ x₁ x₂ x₃ x) x₃
redU*Term′ U′≡U (prodrec-β x x₁ x₂ x₃ x₄ x₅ _) =
  UnotInA[t,u] U′≡U x₃ x₄ x₅
redU*Term′ () (Emptyrec-subst x A⇒U)
redU*Term′ PE.refl (Σ-β₁ F G x x₁ x₂ _) = UnotInA x
redU*Term′ PE.refl (Σ-β₂ F G x x₁ x₂ _) = UnotInA x₁

redU*Term : Γ ⊢ A ⇒* U ∷ B → ⊥
redU*Term (id x) = UnotInA x
redU*Term (x ⇨ A⇒*U) = redU*Term A⇒*U

-- Nothing reduces to U

redU : Γ ⊢ A ⇒ U → ⊥
redU (univ x) = redU*Term′ PE.refl x

redU* : Γ ⊢ A ⇒* U → A PE.≡ U
redU* (id x) = PE.refl
redU* (x ⇨ A⇒*U) rewrite redU* A⇒*U = ⊥-elim (redU x)
