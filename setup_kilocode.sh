git clone --filter=blob:none --no-checkout https://github.com/kinneyyan/prompts.git "${HOME}/temp_prompts" && \
cd "${HOME}/temp_prompts" && \
git sparse-checkout init --cone && \
git sparse-checkout set workflows skills && \
git checkout main && \
mkdir -p "${HOME}/.kilocode/workflows" && \
mkdir -p "${HOME}/.kilocode/skills" && \
(cp -r workflows/* "${HOME}/.kilocode/workflows" || true) && \
(cp -r skills/* "${HOME}/.kilocode/skills" || true) && \
cd .. && \
rm -rf "${HOME}/temp_prompts"