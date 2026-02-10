git clone --filter=blob:none --no-checkout https://github.com/kinneyyan/prompts.git "${HOME}/temp_prompts" && \
cd "${HOME}/temp_prompts" && \
git sparse-checkout init --cone && \
git sparse-checkout set commands skills && \
git checkout main && \
mkdir -p "${HOME}/.claude/commands" && \
mkdir -p "${HOME}/.claude/skills" && \
(cp -r commands/* "${HOME}/.claude/commands" || true) && \
(cp -r skills/* "${HOME}/.claude/skills" || true) && \
cd .. && \
rm -rf "${HOME}/temp_prompts"