module Definition.Typed.Consequences.Reduction
  {a} (M : Set a) where

open import Definition.Untyped M hiding (_∷_)
open import Definition.Typed M
open import Definition.Typed.Properties M
open import Definition.Typed.EqRelInstance M
open import Definition.Typed.Consequences.Syntactic M
open import Definition.LogicalRelation M
open import Definition.LogicalRelation.Properties M
open import Definition.LogicalRelation.Fundamental.Reducibility M

open import Tools.Nat
open import Tools.Product

private
  variable
    n : Nat
    Γ : Con Term n
    p q : M

-- Helper function where all reducible types can be reduced to WHNF.
whNorm′ : ∀ {A l} ([A] : Γ ⊩⟨ l ⟩ A)
                → ∃ λ B → Whnf B × Γ ⊢ A :⇒*: B
whNorm′ (Uᵣ′ .⁰ 0<1 ⊢Γ) = U , Uₙ , idRed:*: (Uⱼ ⊢Γ)
whNorm′ (ℕᵣ D) = ℕ , ℕₙ , D
whNorm′ (Emptyᵣ D) = Empty , Emptyₙ , D
whNorm′ (Unitᵣ D) = Unit , Unitₙ , D
whNorm′ (ne′ K D neK K≡K) = K , ne neK , D
whNorm′ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) = Π _ , _ ▷ F ▹ G , ΠΣₙ , D
whNorm′ (Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) = Σ _ , _ ▷ F ▹ G , ΠΣₙ , D
whNorm′ (emb 0<1 [A]) = whNorm′ [A]

-- Well-formed types can all be reduced to WHNF.
whNorm : ∀ {A} → Γ ⊢ A → ∃ λ B → Whnf B × Γ ⊢ A :⇒*: B
whNorm A = whNorm′ (reducible A)

-- Helper function where reducible all terms can be reduced to WHNF.
whNormTerm′ : ∀ {a A l} ([A] : Γ ⊩⟨ l ⟩ A) → Γ ⊩⟨ l ⟩ a ∷ A / [A]
                → ∃ λ b → Whnf b × Γ ⊢ a :⇒*: b ∷ A
whNormTerm′ (Uᵣ x) (Uₜ A d typeA A≡A [t]) = A , typeWhnf typeA , d
whNormTerm′ (ℕᵣ x) (ℕₜ n d n≡n prop) =
  let natN = natural prop
  in  n , naturalWhnf natN , convRed:*: d (sym (subset* (red x)))
whNormTerm′ (Emptyᵣ x) (Emptyₜ n d n≡n prop) =
  let emptyN = empty prop
  in  n , ne emptyN , convRed:*: d (sym (subset* (red x)))
whNormTerm′ (Unitᵣ x) (Unitₜ n d prop) =
  n , prop , convRed:*: d (sym (subset* (red x)))
whNormTerm′ (ne (ne K D neK K≡K)) (neₜ k d (neNfₜ neK₁ ⊢k k≡k)) =
  k , ne neK₁ , convRed:*: d (sym (subset* (red D)))
whNormTerm′ (Πᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) (Πₜ f d funcF f≡f [f] [f]₁) =
  f , functionWhnf funcF , convRed:*: d (sym (subset* (red D)))
whNormTerm′ (Σᵣ′ F G D ⊢F ⊢G A≡A [F] [G] G-ext) (Σₜ p d p≡p pProd pProp) =
  p , productWhnf pProd , convRed:*: d (sym (subset* (red D)))
whNormTerm′ (emb 0<1 [A]) [a] = whNormTerm′ [A] [a]

-- Well-formed terms can all be reduced to WHNF.
whNormTerm : ∀ {a A} → Γ ⊢ a ∷ A → ∃ λ b → Whnf b × Γ ⊢ a :⇒*: b ∷ A
whNormTerm {a} {A} ⊢a =
  let [A] , [a] = reducibleTerm ⊢a
  in  whNormTerm′ [A] [a]

redMany : ∀ {t u A} → Γ ⊢ t ⇒ u ∷ A → Γ ⊢ t ⇒* u ∷ A
redMany d =
  let _ , _ , ⊢u = syntacticEqTerm (subsetTerm d)
  in  d ⇨ id ⊢u
