open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Properties.MaybeEmb
  {a} (M : Set a) {{eqrel : EqRelSet M}} where

open EqRelSet {{...}}

open import Definition.Untyped M
open import Definition.LogicalRelation M

open import Tools.Nat

private
  variable
    n : Nat
    Γ : Con Term n

-- Any level can be embedded into the highest level.
maybeEmb : ∀ {l A}
         → Γ ⊩⟨ l ⟩ A
         → Γ ⊩⟨ ¹ ⟩ A
maybeEmb {l = ⁰} [A] = emb 0<1 [A]
maybeEmb {l = ¹} [A] = [A]

-- The lowest level can be embedded in any level.
maybeEmb′ : ∀ {l A}
          → Γ ⊩⟨ ⁰ ⟩ A
          → Γ ⊩⟨ l ⟩ A
maybeEmb′ {l = ⁰} [A] = [A]
maybeEmb′ {l = ¹} [A] = emb 0<1 [A]
