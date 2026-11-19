# Guia Rápido: Sincronizar seu Tracker na Nuvem (5 minutos)

Este guia coloca seu tracker no ar de graça via **GitHub Pages** e sincroniza automaticamente seu progresso entre o **PC de casa**, o **navegador de trabalho** e seu **celular (S23 Ultra)** usando um **GitHub Gist Secreto** — sem instalar nada em máquinas compartilhadas e mantendo seus dados pessoais fora do repositório público.

---

## Passo 1 — Publicar o Tracker no GitHub Pages (grátis)

1. Crie um repositório **público** no GitHub com um nome simples, por exemplo: `tracker-dados-2027`.
2. Envie os arquivos deste projeto usando **um dos dois caminhos** abaixo:

### Caminho A — Via Git (recomendado para já praticar!)
O arquivo `.gitignore` já está configurado para **bloquear** `PLANO_10_SEMANAS.md` e arquivos `.json`, então só sobem os arquivos seguros (`index.html`, `tracker.html`, `pratica_sql_semana1.sql`, `README.md`, `GUIA_SYNC_GITHUB.md` e `.gitignore`).

No Terminal (dentro da pasta `plano_dados_2027`):
```powershell
git config --global user.name "Matheus Esmeraldo"
git config --global user.email "seu-email-do-github@exemplo.com"
git init
git add .
git status
git commit -m "Inicial: tracker de estudos"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/tracker-dados-2027.git
git push -u origin main
```

### Caminho B — Rápido pelo navegador (2 minutos)
No repositório recém-criado, clique em **Add file → Upload files**, arraste apenas `index.html` e `README.md` e clique em **Commit changes**.

### Ativar o link do site
1. No repositório do GitHub, abra **Settings → Pages**.
2. Em **Build and deployment / Source**, selecione **Deploy from a branch**.
3. Escolha a branch **`main`** e a pasta **`/ (root)`**, depois clique em **Save**.
4. Aguarde ~1 minuto e atualize a página: seu tracker estará no ar em:
   `https://SEU-USUARIO.github.io/tracker-dados-2027/`

---

## Passo 2 — Criar o Token mínimo do GitHub (1 minuto)

1. No GitHub (canto superior direito → sua foto), abra **Settings**.
2. No menu lateral esquerdo (lá embaixo), clique em **Developer settings**.
3. Entre em **Personal access tokens → Tokens (classic)**.
4. Clique em **Generate new token → Generate new token (classic)**.
5. Preencha:
   - **Note:** `tracker-dados-2027`
   - **Expiration:** `90 days` (ou outro prazo de sua preferência)
   - **Select scopes:** marque **APENAS a caixa `gist`** (não precisa marcar `repo` nem nenhuma outra!)
6. Clique em **Generate token** e copie o código que começa com `ghp_...` (salve no seu gerenciador de senhas ou local seguro, pois o GitHub mostra só uma vez).

---

## Passo 3 — Conectar Casa, Trabalho e Celular (S23 Ultra)

1. Abra sua URL `https://SEU-USUARIO.github.io/tracker-dados-2027/` no **primeiro dispositivo** (ex.: seu PC em casa).
2. Clique no botão **`☁️ Sync: Local (Configurar)`** no cabeçalho.
3. Cole seu token `ghp_...`, deixe o campo **Gist ID** em branco e clique em **Conectar e Sincronizar**.
   - Ele criará automaticamente um **Gist Secreto (`progresso_dados_2027.json`)** na sua conta!
4. Agora abra a mesma URL no **navegador do trabalho** (de preferência em um perfil separado) e no **celular**:
   - Clique em `☁️ Sync: Local (Configurar)`, cole o **mesmo token**, deixe o **Gist ID** vazio e clique em **Conectar e Sincronizar**.
   - Ele encontra seu Gist automaticamente e baixa todo o seu progresso!

### Dicas de Segurança
- A partir daí, cada checkbox marcado, bloco concluído ou anotação sincroniza sozinho com a nuvem (~1,5 segundo após parar de digitar).
- Se algum dia você abrir o tracker em um computador compartilhado ou emprestado, clique em **`☁️ Sincronizado`** e depois em **`Desconectar deste navegador`** ao terminar.
