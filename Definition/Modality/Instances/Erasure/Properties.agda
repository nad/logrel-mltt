open import Definition.Modality.Instances.Erasure
open import Definition.Modality.Restrictions

module Definition.Modality.Instances.Erasure.Properties
  (restrictions : Restrictions Erasure)
  where

open import Definition.Modality.Instances.Erasure.Modality restrictions

open import Definition.Modality.Context ErasureModality
open import Definition.Modality.Context.Properties ErasureModality public

open import Definition.Modality.Properties ErasureModality public

open import Definition.Modality.Usage ErasureModality
open import Definition.Modality.Usage.Inversion ErasureModality
open import Definition.Mode ErasureModality

open import Definition.Untyped Erasure

open import Tools.Fin
open import Tools.Nat hiding (_+_)
open import Tools.PropositionalEquality as PE using (_≡_)
import Tools.Reasoning.PartialOrder

private
  variable
    m n : Nat
    σ σ′ : Subst m n
    γ δ : Conₘ n
    t u a : Term n
    x : Fin n
    p : Erasure
    mo : Mode

-- Addition on the left is a decreasing function
-- γ + δ ≤ᶜ γ

+-decreasingˡ : (p q : Erasure) → (p + q) ≤ p
+-decreasingˡ 𝟘 𝟘 = PE.refl
+-decreasingˡ 𝟘 ω = PE.refl
+-decreasingˡ ω 𝟘 = PE.refl
+-decreasingˡ ω ω = PE.refl

-- Addition on the right is a decreasing function
-- γ + δ ≤ᶜ δ

+-decreasingʳ : (p q : Erasure) → (p + q) ≤ q
+-decreasingʳ 𝟘 𝟘 = PE.refl
+-decreasingʳ 𝟘 ω = PE.refl
+-decreasingʳ ω 𝟘 = PE.refl
+-decreasingʳ ω ω = PE.refl

-- Addition on the left is a decreasing function
-- γ +ᶜ δ ≤ᶜ γ

+ᶜ-decreasingˡ : (γ δ : Conₘ n) → γ +ᶜ δ ≤ᶜ γ
+ᶜ-decreasingˡ ε ε = ≤ᶜ-refl
+ᶜ-decreasingˡ (γ ∙ p) (δ ∙ q) = (+ᶜ-decreasingˡ γ δ) ∙ (+-decreasingˡ p q)

-- Addition on the right is a decreasing function
-- γ +ᶜ δ ≤ᶜ δ

+ᶜ-decreasingʳ : (γ δ : Conₘ n) → γ +ᶜ δ ≤ᶜ δ
+ᶜ-decreasingʳ ε ε = ≤ᶜ-refl
+ᶜ-decreasingʳ (γ ∙ p) (δ ∙ q) = (+ᶜ-decreasingʳ γ δ) ∙ (+-decreasingʳ p q)

-- Addition is idempotent
-- γ +ᶜ γ ≡ γ

+ᶜ-idem : (γ : Conₘ n) → γ +ᶜ γ PE.≡ γ
+ᶜ-idem ε = PE.refl
+ᶜ-idem (γ ∙ p) = PE.cong₂ _∙_ (+ᶜ-idem γ) (+-Idempotent p)

-- ⊛ᵣ is a decreasing function on its first argument
-- p ⊛ q ▷ r ≤ p

⊛-decreasingˡ : (p q r : Erasure) → p ⊛ q ▷ r ≤ p
⊛-decreasingˡ 𝟘 𝟘 r = PE.refl
⊛-decreasingˡ 𝟘 ω r = PE.refl
⊛-decreasingˡ ω 𝟘 r = PE.refl
⊛-decreasingˡ ω ω r = PE.refl

-- ⊛ᵣ is a decreasing function on its second argument
-- p ⊛ q ▷ r ≤ q

⊛-decreasingʳ : (p q r : Erasure) → p ⊛ q ▷ r ≤ q
⊛-decreasingʳ 𝟘 𝟘 r = PE.refl
⊛-decreasingʳ 𝟘 ω 𝟘 = PE.refl
⊛-decreasingʳ 𝟘 ω ω = PE.refl
⊛-decreasingʳ ω 𝟘 r = PE.refl
⊛-decreasingʳ ω ω r = PE.refl


-- ⊛ᶜ is a decreasing function on its first argument
-- γ ⊛ᶜ δ ▷ r ≤ᶜ γ

⊛ᶜ-decreasingˡ : (γ δ : Conₘ n) (r : Erasure) → γ ⊛ᶜ δ ▷ r ≤ᶜ γ
⊛ᶜ-decreasingˡ ε ε r = ≤ᶜ-refl
⊛ᶜ-decreasingˡ (γ ∙ 𝟘) (δ ∙ 𝟘) r = (⊛ᶜ-decreasingˡ γ δ r) ∙ PE.refl
⊛ᶜ-decreasingˡ (γ ∙ 𝟘) (δ ∙ ω) r = (⊛ᶜ-decreasingˡ γ δ r) ∙ PE.refl
⊛ᶜ-decreasingˡ (γ ∙ ω) (δ ∙ 𝟘) r = (⊛ᶜ-decreasingˡ γ δ r) ∙ PE.refl
⊛ᶜ-decreasingˡ (γ ∙ ω) (δ ∙ ω) r = (⊛ᶜ-decreasingˡ γ δ r) ∙ PE.refl

-- ⊛ᶜ is a decreasing function on its second argument
-- γ ⊛ᶜ δ ▷ r ≤ᶜ δ

⊛ᶜ-decreasingʳ : (γ δ : Conₘ n) (r : Erasure)  → γ ⊛ᶜ δ ▷ r ≤ᶜ δ
⊛ᶜ-decreasingʳ ε ε r = ≤ᶜ-refl
⊛ᶜ-decreasingʳ (γ ∙ 𝟘) (δ ∙ 𝟘) r = ⊛ᶜ-decreasingʳ γ δ r ∙ PE.refl
⊛ᶜ-decreasingʳ (γ ∙ 𝟘) (δ ∙ ω) r = ⊛ᶜ-decreasingʳ γ δ r ∙ PE.refl
⊛ᶜ-decreasingʳ (γ ∙ ω) (δ ∙ 𝟘) r = ⊛ᶜ-decreasingʳ γ δ r ∙ PE.refl
⊛ᶜ-decreasingʳ (γ ∙ ω) (δ ∙ ω) r = ⊛ᶜ-decreasingʳ γ δ r ∙ PE.refl

-- 𝟘 is the greatest element of the erasure modality
-- p ≤ 𝟘

greatest-elem : (p : Erasure) → p ≤ 𝟘
greatest-elem 𝟘 = PE.refl
greatest-elem ω = PE.refl

-- ω is the least element of the erasure modality
-- ω ≤ p

least-elem : (p : Erasure) → ω ≤ p
least-elem p = PE.refl

-- 𝟘 is the greatest element of the erasure modality
-- If 𝟘 ≤ p then p ≡ 𝟘

greatest-elem′ : (p : Erasure) → 𝟘 ≤ p → p PE.≡ 𝟘
greatest-elem′ p 𝟘≤p = ≤-antisym (greatest-elem p) 𝟘≤p

-- ω is the least element of the erasure modality
-- If p ≤ ω then p ≡ ω

least-elem′ : (p : Erasure) → p ≤ ω → p PE.≡ ω
least-elem′ p p≤ω = ≤-antisym p≤ω (least-elem p)

-- 𝟘ᶜ is the greatest erasure modality context
-- γ ≤ 𝟘ᶜ

greatest-elemᶜ : (γ : Conₘ n) → γ ≤ᶜ 𝟘ᶜ
greatest-elemᶜ ε = ε
greatest-elemᶜ (γ ∙ p) = (greatest-elemᶜ γ) ∙ (greatest-elem p)

-- 𝟙ᶜ is the least erasure modality context
-- 𝟙ᶜ ≤ γ

least-elemᶜ : (γ : Conₘ n) → 𝟙ᶜ ≤ᶜ γ
least-elemᶜ ε = ε
least-elemᶜ (γ ∙ p) = (least-elemᶜ γ) ∙ (least-elem p)

-- If a variable is well-used in the mode 𝟙ᵐ, with usage vector γ,
-- then the variable's usage in γ is ω.

valid-var-usage : γ ▸[ 𝟙ᵐ ] var x → x ◂ ω ∈ γ
valid-var-usage γ▸x with inv-usage-var γ▸x
valid-var-usage {x = x0} γ▸x | γ≤𝟘ᶜ ∙ p≤ω rewrite least-elem′ _ p≤ω = here
valid-var-usage {x = x +1} γ▸x | γ≤γ′ ∙ p≤𝟘 = there (valid-var-usage (sub var γ≤γ′))

-- The functions _∧ᶜ_ and _+ᶜ_ are pointwise equivalent.

∧ᶜ≈ᶜ+ᶜ : γ ∧ᶜ δ ≈ᶜ γ +ᶜ δ
∧ᶜ≈ᶜ+ᶜ {γ = ε}     {δ = ε}     = ≈ᶜ-refl
∧ᶜ≈ᶜ+ᶜ {γ = _ ∙ _} {δ = _ ∙ _} = ∧ᶜ≈ᶜ+ᶜ ∙ PE.refl

-- Subsumption for erased variables

erased-var-sub : x ◂ 𝟘 ∈ γ → γ ≤ᶜ δ → x ◂ 𝟘 ∈ δ
erased-var-sub {δ = δ ∙ q} here (γ≤δ ∙ PE.refl) = here
erased-var-sub {δ = δ ∙ q} (there x◂𝟘) (γ≤δ ∙ p≤q) = there (erased-var-sub x◂𝟘 γ≤δ)

-- Inversion lemma for any products

inv-usage-prodₑ :
  ∀ {m} → γ ▸[ mo ] prod m p t u → InvUsageProdᵣ γ mo p t u
inv-usage-prodₑ {γ = γ} {p = p} {m = Σₚ} γ▸t with inv-usage-prodₚ γ▸t
... | invUsageProdₚ {δ = δ} {η = η} δ▸t δ▸u γ≤ =
  invUsageProdᵣ δ▸t δ▸u (begin
    γ            ≤⟨ γ≤ ⟩
    p ·ᶜ δ ∧ᶜ η  ≈⟨ ∧ᶜ≈ᶜ+ᶜ ⟩
    p ·ᶜ δ +ᶜ η  ∎)
  where
  open Tools.Reasoning.PartialOrder ≤ᶜ-poset
inv-usage-prodₑ {m = Σᵣ} γ▸t = inv-usage-prodᵣ γ▸t

-- The mode corresponding to ω is 𝟙ᵐ.

⌞ω⌟≡𝟙ᵐ : ⌞ ω ⌟ ≡ 𝟙ᵐ
⌞ω⌟≡𝟙ᵐ = 𝟙ᵐ′≡𝟙ᵐ
