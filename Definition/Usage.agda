open import Definition.Modality

module Definition.Usage
  {a} {M : Set a} (𝕄 : Modality M) where

open Modality 𝕄

open import Definition.Modality.Context 𝕄
open import Definition.Modality.Usage 𝕄
open import Definition.Mode 𝕄
open import Definition.Untyped M hiding (_∷_)
open import Definition.Typed M

open import Tools.Nat
open import Tools.Product

private
  variable
    n : Nat

infix 22 _▷_▹▹_
infix 22 _▷_××_

-- Combined well-typed and usage relations

_⊢_[_]◂_ :
  (Γ : Con Term n) (A : Term n) (m : Mode) (γ : Conₘ n) → Set a
Γ ⊢ A [ m ]◂ γ = (Γ ⊢ A) × (γ ▸[ m ] A)

_⊢_▸[_]_∷_[_]◂_ :
  (Γ : Con Term n) (γ : Conₘ n) (m : Mode)
  (t A : Term n) (m′ : Mode) (δ : Conₘ n) →
  Set a
Γ ⊢ γ ▸[ m ] t ∷ A [ m′ ]◂ δ =
  (Γ ⊢ t ∷ A) × (γ ▸[ m ] t) × (δ ▸[ m′ ] A)

-- Non-dependent version of Π.

_▷_▹▹_ : (p : M) → (F G : Term n) → Term n
p ▷ F ▹▹ G = Π p , 𝟘 ▷ F ▹ wk1 G

-- Non-dependent products.

_▷_××_ : {m : SigmaMode} (p : M) (F G : Term n) → Term n
_▷_××_ {m = m} p F G = Σ⟨ m ⟩ p , 𝟘 ▷ F ▹ wk1 G
