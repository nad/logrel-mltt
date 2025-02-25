open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Substitution.Escape
  {a} (M : Set a) {{eqrel : EqRelSet M}} where

open EqRelSet {{...}}

open import Definition.Untyped M hiding (_∷_)
open import Definition.Untyped.Properties M

open import Definition.Typed M

open import Definition.LogicalRelation.Irrelevance M
open import Definition.LogicalRelation.Properties M
open import Definition.LogicalRelation.Substitution M
open import Definition.LogicalRelation.Substitution.Properties M

open import Tools.Nat
open import Tools.Product

private
  variable
    n : Nat
    Γ : Con Term n

-- Valid types are well-formed.
escapeᵛ : ∀ {A l} ([Γ] : ⊩ᵛ Γ) → Γ ⊩ᵛ⟨ l ⟩ A / [Γ] → Γ ⊢ A
escapeᵛ [Γ] [A] =
  let ⊢Γ = soundContext [Γ]
      idSubst = idSubstS [Γ]
  in  escape (irrelevance′ (subst-id _) (proj₁ (unwrap [A] ⊢Γ idSubst)))

-- Valid type equality respects the equality relation.
escapeEqᵛ : ∀ {A B l} ([Γ] : ⊩ᵛ Γ) ([A] : Γ ⊩ᵛ⟨ l ⟩ A / [Γ])
              → Γ ⊩ᵛ⟨ l ⟩ A ≡ B / [Γ] / [A] → Γ ⊢ A ≅ B
escapeEqᵛ [Γ] [A] [A≡B] =
  let ⊢Γ = soundContext [Γ]
      idSubst = idSubstS [Γ]
      [idA]  = proj₁ (unwrap [A] ⊢Γ idSubst)
      [idA]′ = irrelevance′ (subst-id _) [idA]
  in  escapeEq [idA]′ (irrelevanceEq″ (subst-id _) (subst-id _)
                                           [idA] [idA]′ ([A≡B] ⊢Γ idSubst))

-- Valid terms are well-formed.
escapeTermᵛ : ∀ {t A l} ([Γ] : ⊩ᵛ Γ) ([A] : Γ ⊩ᵛ⟨ l ⟩ A / [Γ])
               → Γ ⊩ᵛ⟨ l ⟩ t ∷ A / [Γ] / [A] → Γ ⊢ t ∷ A
escapeTermᵛ [Γ] [A] [t] =
  let ⊢Γ = soundContext [Γ]
      idSubst = idSubstS [Γ]
      [idA]  = proj₁ (unwrap [A] ⊢Γ idSubst)
      [idA]′ = irrelevance′ (subst-id _) (proj₁ (unwrap [A] ⊢Γ idSubst))
  in  escapeTerm [idA]′
                    (irrelevanceTerm″ (subst-id _) (subst-id _)
                                       [idA] [idA]′ (proj₁ ([t] ⊢Γ idSubst)))

-- Valid term equality respects the equality relation.
escapeEqTermᵛ : ∀ {t u A l} ([Γ] : ⊩ᵛ Γ) ([A] : Γ ⊩ᵛ⟨ l ⟩ A / [Γ])
               → Γ ⊩ᵛ⟨ l ⟩ t ≡ u ∷ A / [Γ] / [A] → Γ ⊢ t ≅ u ∷ A
escapeEqTermᵛ [Γ] [A] [t≡u] =
  let ⊢Γ = soundContext [Γ]
      idSubst = idSubstS [Γ]
      [idA]  = proj₁ (unwrap [A] ⊢Γ idSubst)
      [idA]′ = irrelevance′ (subst-id _) (proj₁ (unwrap [A] ⊢Γ idSubst))
  in  escapeTermEq [idA]′
                       (irrelevanceEqTerm″ (subst-id _) (subst-id _)
                                            (subst-id _)
                                            [idA] [idA]′ ([t≡u] ⊢Γ idSubst))
