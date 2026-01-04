# ⌨️ Configuration Neovim - Documentation des Keymaps

Cette documentation récapitule l'ensemble des raccourcis clavier de ta configuration, incluant la navigation, le développement Java/Angular et l'intégration avec WezTerm.

---

## 🚀 Exécution de Projets (Intégration WezTerm)
*Ces commandes ouvrent un split à droite (25%) et attendent une pression sur Entrée avant de se fermer.*

| Raccourci | Action | Commande |
| :--- | :--- | :--- |
| `<leader>ns` | **Npm run start** | Lance le projet Angular / Node |
| `<leader>ms` | **Maven Spring Run** | Lance le projet Spring Boot |

---

## 📂 Navigation & Explorateur
| Raccourci | Action | Plugin |
| :--- | :--- | :--- |
| `<leader>e` | Ouvrir Oil (Explorateur) | `oil.nvim` |
| `<leader>ac` | **Angular CLI (ng g)** | `oil.nvim` |
| `<leader>ff` | Rechercher un fichier | `telescope` |
| `<leader>fg` | Rechercher un fichier Git | `telescope` |
| `<leader>fs` | Rechercher du texte (Grep) | `telescope` |
| `<leader>fb` | Lister les buffers ouverts | `telescope` |

---

## ☕ Java & LSP (Navigation & Refactoring)
*Fonctionne pour Java, TypeScript (Angular) et Lua.*

| Raccourci | Action | Description |
| :--- | :--- | :--- |
| `gd` | Go to Definition | Va à la source du symbole |
| `gi` | Go to Implementation | Affiche les implémentations |
| `gr` | References | Liste les usages via Telescope |
| `K` | Hover Doc | Affiche la documentation (Javadoc) |
| **`<leader>rn`** | **Rename** | **Renomme partout (Classe, Variable)** |
| `<leader>ca` | Code Action | Menu de corrections rapides |
| `<leader>db` | Database UI | Toggle l'interface SQL (Dadbod) |

---

## 🪟 Gestion des Fenêtres (Smart-Splits)
| Raccourci | Action |
| :--- | :--- |
| `<C-h / j / k / l>` | Naviguer entre les fenêtres (G, B, H, D) |
| `<A-h / j / k / l>` | Redimensionner les fenêtres (G, B, H, D) |

---

## ⌨️ Mode Insertion (Complétion)
| Raccourci | Action |
| :--- | :--- |
| `<C-Space>` | Forcer la complétion |
| `<CR>` | Valider la sélection |
| `<C-e>` | Annuler / Fermer |
| `<C-f> / <C-b>` | Scroller dans la documentation |

---

## 🎨 Interface
- **Thème** : Catppuccin Mocha
- **Statusline** : Lualine (Thème Catppuccin)
- **Notifications** : Nvim-notify (Compact, 3s)
- **LSP Progress** : Fidget.nvim
