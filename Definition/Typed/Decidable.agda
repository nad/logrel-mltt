open import Tools.PropositionalEquality as PE using (_≈_)
open import Tools.Relation

module Definition.Typed.Decidable
  {a} {M : Set a} (_≟_ : Decidable (_≈_ {A = M})) where

open import Definition.Untyped M hiding (_∷_)
open import Definition.Typed M
open import Definition.Conversion.Decidable _≟_
open import Definition.Conversion.Soundness M
open import Definition.Conversion.Consequences.Completeness M

open import Tools.Nat
open import Tools.Nullary

private
  variable
    n : Nat
    Γ : Con Term n

-- Decidability of conversion of well-formed types
dec : ∀ {A B} → Γ ⊢ A → Γ ⊢ B → Dec (Γ ⊢ A ≡ B)
dec ⊢A ⊢B = map soundnessConv↑ completeEq
                (decConv↑ (completeEq (refl ⊢A))
                          (completeEq (refl ⊢B)))

-- Decidability of conversion of well-formed terms
decTerm : ∀ {t u A} → Γ ⊢ t ∷ A → Γ ⊢ u ∷ A → Dec (Γ ⊢ t ≡ u ∷ A)
decTerm ⊢t ⊢u = map soundnessConv↑Term completeEqTerm
                    (decConv↑Term (completeEqTerm (refl ⊢t))
                                  (completeEqTerm (refl ⊢u)))
