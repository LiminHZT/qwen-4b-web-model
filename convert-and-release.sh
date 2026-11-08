#!/usr/bin/env bash
set -euo pipefail

SOURCE_REPO="${1:-DreamFast/Qwen3.5-4B-Uncensored-HauhauCS-Aggressive-Safetensor-Benchmark}"
HF_ENDPOINT="${HF_ENDPOINT:-https://hf-mirror.com}"
export HF_ENDPOINT HF_HUB_DISABLE_XET=1

python -m pip install --pre -U mlc-llm mlc-ai huggingface_hub
hf download "$SOURCE_REPO" --local-dir ./source-model
mkdir -p ./web-model
mlc_llm convert_weight ./source-model --quantization q4f16_1 --output ./web-model
mlc_llm gen_config ./source-model --quantization q4f16_1 --conv-template qwen3_5 --output ./web-model

test -f ./web-model/mlc-chat-config.json
test -f ./web-model/tokenizer.json
test -f ./web-model/tensor-cache.json || test -f ./web-model/ndarray-cache.json
find ./web-model -maxdepth 1 -name 'params_shard_*.bin' | grep -q .

gh release view v1.0 --repo LiminHZT/qwen-4b-web-model >/dev/null 2>&1 || \
  gh release create v1.0 --repo LiminHZT/qwen-4b-web-model \
    --title "Qwen3.5 4B Uncensored WebLLM q4f16_1"
for file in ./web-model/*; do
  gh release upload v1.0 "$file" --repo LiminHZT/qwen-4b-web-model --clobber
done
