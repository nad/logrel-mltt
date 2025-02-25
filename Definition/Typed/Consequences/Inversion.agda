module Definition.Typed.Consequences.Inversion
  {a} (M : Set a) where

open import Definition.Untyped M hiding (_∷_)
open import Definition.Typed M
open import Definition.Typed.Properties M

open import Definition.Typed.Consequences.Syntactic M
open import Definition.Typed.Consequences.Substitution M
open import Definition.Typed.Consequences.Inequality M

open import Tools.Fin
open import Tools.Nat
open import Tools.Product
open import Tools.Empty using (⊥; ⊥-elim)

private
  variable
    n : Nat
    Γ : Con Term n
    p p′ q q′ r : M
    b : BinderMode

-- Inversion of U (it has no type).
inversion-U : ∀ {C} → Γ ⊢ U ∷ C → ⊥
inversion-U (conv x x₁) = inversion-U x

-- Inversion of natural number type.
inversion-ℕ : ∀ {C} → Γ ⊢ ℕ ∷ C → Γ ⊢ C ≡ U
inversion-ℕ (ℕⱼ x) = refl (Uⱼ x)
inversion-ℕ (conv x x₁) = trans (sym x₁) (inversion-ℕ x)

-- Inversion of Empty.
inversion-Empty : ∀ {C} → Γ ⊢ Empty ∷ C → Γ ⊢ C ≡ U
inversion-Empty (Emptyⱼ x) = refl (Uⱼ x)
inversion-Empty (conv x x₁) = trans (sym x₁) (inversion-Empty x)

-- Inversion of Unit.
inversion-Unit : ∀ {C} → Γ ⊢ Unit ∷ C → Γ ⊢ C ≡ U
inversion-Unit (Unitⱼ x) = refl (Uⱼ x)
inversion-Unit (conv x x₁) = trans (sym x₁) (inversion-Unit x)

-- Inversion of Π- and Σ-types.
inversion-ΠΣ :
  ∀ {F G C} →
  Γ ⊢ ΠΣ⟨ b ⟩ p , q ▷ F ▹ G ∷ C →
  Γ ⊢ F ∷ U × Γ ∙ F ⊢ G ∷ U × Γ ⊢ C ≡ U
inversion-ΠΣ (ΠΣⱼ x ▹ x₁) = x , x₁ , refl (Uⱼ (wfTerm x))
inversion-ΠΣ (conv x x₁)  =
  let a , b , c = inversion-ΠΣ x
  in  a , b , trans (sym x₁) c

-- Inversion of variables
inversion-var : ∀ {x C} → Γ ⊢ var x ∷ C → ∃ λ A → x ∷ A ∈ Γ × Γ ⊢ C ≡ A
inversion-var ⊢x@(var x x₁) =
  let ⊢C = syntacticTerm ⊢x
  in  _ , x₁ , refl ⊢C
inversion-var (conv x x₁) =
  let a , b , c = inversion-var x
  in  a , b , trans (sym x₁) c

-- Inversion of zero.
inversion-zero : ∀ {C} → Γ ⊢ zero ∷ C → Γ ⊢ C ≡ ℕ
inversion-zero (zeroⱼ x) = refl (ℕⱼ x)
inversion-zero (conv x x₁) = trans (sym x₁) (inversion-zero x)

-- Inversion of successor.
inversion-suc : ∀ {t C} → Γ ⊢ suc t ∷ C → Γ ⊢ t ∷ ℕ × Γ ⊢ C ≡ ℕ
inversion-suc (sucⱼ x) = x , refl (ℕⱼ (wfTerm x))
inversion-suc (conv x x₁) =
  let a , b = inversion-suc x
  in  a , trans (sym x₁) b

-- Inversion of natural recursion.
inversion-natrec : ∀ {c g n A C} → Γ ⊢ natrec p q r C c g n ∷ A
  → (Γ ∙ ℕ ⊢ C)
  × Γ ⊢ c ∷ C [ zero ]
  × Γ ∙ ℕ ∙ C ⊢ g ∷ wk1 (C [ suc (var x0) ]↑)
  × Γ ⊢ n ∷ ℕ
  × Γ ⊢ A ≡ C [ n ]
inversion-natrec (natrecⱼ x d d₁ n) = x , d , d₁ , n , refl (substType x n)
inversion-natrec (conv d x) = let a , b , c , d , e = inversion-natrec d
                              in  a , b , c , d , trans (sym x) e

-- Inversion of application.
inversion-app :  ∀ {f a A} → Γ ⊢ f ∘⟨ p ⟩ a ∷ A →
  ∃₃ λ F G q → Γ ⊢ f ∷ Π p , q ▷ F ▹ G × Γ ⊢ a ∷ F × Γ ⊢ A ≡ G [ a ]
inversion-app (d ∘ⱼ d₁) = _ , _ , _ , d , d₁ , refl (substTypeΠ (syntacticTerm d) d₁)
inversion-app (conv d x) = let a , b , c , d , e , f = inversion-app d
                           in  a , b , c , d , e , trans (sym x) f

-- Inversion of lambda.
inversion-lam : ∀ {t A} → Γ ⊢ lam p t ∷ A →
  ∃₃ λ F G q → Γ ⊢ F × (Γ ∙ F ⊢ t ∷ G × Γ ⊢ A ≡ Π p , q ▷ F ▹ G)
inversion-lam (lamⱼ x x₁) = _ , _ , _ , x , x₁ , refl (ΠΣⱼ x ▹ (syntacticTerm x₁))
inversion-lam (conv x x₁) = let a , b , c , d , e , f = inversion-lam x
                            in  a , b , c , d , e , trans (sym x₁) f

-- Inversion of products.
inversion-prod :
  ∀ {t u A m} →
  Γ ⊢ prod m p t u ∷ A →
  ∃₃ λ F G q →
    (Γ ⊢ F) ×
    (Γ ∙ F ⊢ G) ×
    (Γ ⊢ t ∷ F) ×
    (Γ ⊢ u ∷ G [ t ]) ×
    Γ ⊢ A ≡ Σ⟨ m ⟩ p , q ▷ F ▹ G
  -- NOTE fundamental theorem not required since prodⱼ has inversion built-in.
inversion-prod (prodⱼ ⊢F ⊢G ⊢t ⊢u) = _ , _ , _ , ⊢F , ⊢G , ⊢t , ⊢u , refl (ΠΣⱼ ⊢F ▹ ⊢G)
inversion-prod (conv x x₁) =
  let F , G , q , a , b , c , d , e = inversion-prod x
  in F , G , q , a , b , c , d , trans (sym x₁) e

-- Inversion of projections
inversion-fst : ∀ {t A} → Γ ⊢ fst p t ∷ A →
  ∃₃ λ F G q →
    Γ ⊢ F × Γ ∙ F ⊢ G ×
    (Γ ⊢ t ∷ Σₚ p , q ▷ F ▹ G) × (Γ ⊢ A ≡ F)
inversion-fst (fstⱼ ⊢F ⊢G ⊢t) = _ , _ , _ , ⊢F , ⊢G , ⊢t , refl ⊢F
inversion-fst (conv ⊢t x) =
  let F , G , q , a , b , c , d = inversion-fst ⊢t
  in  F , G , q , a , b , c , trans (sym x) d

inversion-snd : ∀ {t A} → Γ ⊢ snd p t ∷ A →
  ∃₃ λ F G q →
    Γ ⊢ F × Γ ∙ F ⊢ G ×
    (Γ ⊢ t ∷ Σₚ p , q ▷ F ▹ G) × (Γ ⊢ A ≡ G [ fst p t ])
inversion-snd (sndⱼ ⊢F ⊢G ⊢t) =
  _ , _ , _ , ⊢F , ⊢G , ⊢t , refl (substType ⊢G (fstⱼ ⊢F ⊢G ⊢t))
inversion-snd (conv ⊢t x) =
  let F , G , q , a , b , c , d = inversion-snd ⊢t
  in  F , G , q , a , b , c , trans (sym x) d

-- Inversion of prodrec
inversion-prodrec :
  ∀ {t u A C} →
  Γ ⊢ prodrec r p q′ C t u ∷ A →
  ∃₃ λ F G q →
    (Γ ⊢ F) ×
    (Γ ∙ F ⊢ G) ×
    (Γ ∙ (Σᵣ p , q ▷ F ▹ G) ⊢ C) ×
    Γ ⊢ t ∷ Σᵣ p , q ▷ F ▹ G ×
    Γ ∙ F ∙ G ⊢ u ∷ C [ prodᵣ p (var (x0 +1)) (var x0) ]↑² ×
    Γ ⊢ A ≡ C [ t ]
inversion-prodrec (prodrecⱼ ⊢F ⊢G ⊢C ⊢t ⊢u) =
  _ , _ , _ , ⊢F , ⊢G , ⊢C , ⊢t , ⊢u , refl (substType ⊢C ⊢t)
inversion-prodrec (conv x x₁) =
  let F , G , q , a , b , c , d , e , f = inversion-prodrec x
  in  F , G , q , a , b , c , d , e , trans (sym x₁) f

-- Inversion of star.
inversion-star : ∀ {C} → Γ ⊢ star ∷ C → Γ ⊢ C ≡ Unit
inversion-star (starⱼ x) = refl (Unitⱼ x)
inversion-star (conv x x₁) = trans (sym x₁) (inversion-star x)

-- Inversion of Emptyrec
inversion-Emptyrec : ∀ {C A t} → Γ ⊢ Emptyrec p A t ∷ C
                   → (Γ ⊢ A) × (Γ ⊢ t ∷ Empty) × Γ ⊢ C ≡ A
inversion-Emptyrec (Emptyrecⱼ x ⊢t) = x , ⊢t , refl x
inversion-Emptyrec (conv ⊢t x) =
  let q , w , e = inversion-Emptyrec ⊢t
  in  q , w , trans (sym x) e

-- Inversion of products in WHNF.
whnfProduct :
  ∀ {p F G m} →
  Γ ⊢ p ∷ Σ⟨ m ⟩ p′ , q ▷ F ▹ G → Whnf p → Product p
whnfProduct x prodₙ = prodₙ
whnfProduct x (ne pNe) = ne pNe

whnfProduct x Uₙ = ⊥-elim (inversion-U x)
whnfProduct x ΠΣₙ =
  let _ , _ , Σ≡U = inversion-ΠΣ x
  in  ⊥-elim (U≢Σ (sym Σ≡U))
whnfProduct x ℕₙ = ⊥-elim (U≢Σ (sym (inversion-ℕ x)))
whnfProduct x Unitₙ = ⊥-elim (U≢Σ (sym (inversion-Unit x)))
whnfProduct x Emptyₙ = ⊥-elim (U≢Σ (sym (inversion-Empty x)))
whnfProduct x lamₙ =
  let _ , _ , _ , _ , _ , Σ≡Π = inversion-lam x
  in  ⊥-elim (Π≢Σⱼ (sym Σ≡Π))
whnfProduct x zeroₙ = ⊥-elim (ℕ≢Σ (sym (inversion-zero x)))
whnfProduct x sucₙ =
  let _ , A≡ℕ = inversion-suc x
  in  ⊥-elim (ℕ≢Σ (sym A≡ℕ))
whnfProduct x starₙ = ⊥-elim (Unit≢Σⱼ (sym (inversion-star x)))
