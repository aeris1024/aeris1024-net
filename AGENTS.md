# Repository instructions

## Project scope

- This repository contains a small static personal website built with plain HTML, CSS, and image assets.
- Keep the implementation simple. Do not introduce a framework, package manager, build system, or production dependency unless the user explicitly requests it.
- Treat page copy, links, language choices, layout, and visual details as mutable content. Follow the current user request rather than preserving old content rules.

## Editing expectations

- Preserve the existing static-site structure unless a requested change requires otherwise.
- When changing `style.css`, update its cache-busting query parameter in `index.html` so returning visitors receive the new stylesheet.
- Do not add content-specific assertions to the validation script unless the user explicitly requests them.

## Validation

- Before committing or publishing changes, run:

  ```powershell
  pwsh -NoProfile -File scripts/validate-site.ps1
  git diff --check
  ```

- Keep `scripts/validate-site.ps1` intentionally minimal. It should only catch missing or empty required files, missing basic HTML document elements, and unbalanced CSS braces.
- Do not claim that visual browser testing was performed unless it was actually requested and completed.

## Git and deployment

- Merging or pushing changes to `main` can deploy the website to the production Sakura VPS through GitHub Actions.
- Use a feature branch and pull request by default for production-facing changes. Let the user make the final merge decision unless they explicitly request a direct production update.
- Never commit or print private keys, passwords, GitHub Secrets, or other credentials.
- Do not change VPS users, SSH keys, permissions, GitHub Secrets, or deployment destinations without explicit user approval.
