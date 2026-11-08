# Qwen3.5 4B WebLLM Model

目标模型：`HauhauCS/Qwen3.5-4B-Uncensored-HauhauCS-Aggressive`。

页面模型目录：`https://github.com/LiminHZT/qwen-4b-web-model/releases/download/v1.0/`。

## 转换

`mlc_llm convert_weight` 应读取 Hugging Face Transformers 模型目录，而不是 GGUF。请从原模型转换，避免从 Q4_K_M GGUF 二次量化。

```bash
python -m pip install --pre -U mlc-llm mlc-ai huggingface_hub
huggingface-cli download HauhauCS/Qwen3.5-4B-Uncensored-HauhauCS-Aggressive --local-dir ./source-model
mlc_llm convert_weight ./source-model --quantization q4f16_1 --output ./web-model
```

上传 `./web-model` 中的全部文件，包括 `mlc-chat-config.json`、`tensor-cache.json`（或旧版的 `ndarray-cache.json`）、`params_shard_*.bin` 和 tokenizer 文件：

```bash
gh release create v1.0 ./web-model/* --repo LiminHZT/qwen-4b-web-model --title "Qwen3.5 4B Uncensored WebLLM q4f16_1"
```

保留权重分片，不要合并成单个大文件。Releases 不需要 Git LFS。

WebLLM 0.2.87 可复用同架构运行库：

`https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/main/web-llm-models/v0_2_87/base/Qwen3.5-4B-q4f16_1_cs1k-webgpu.wasm`

若转换配置与官方 Qwen3.5-4B 不一致，则需针对转换后的 `mlc-chat-config.json` 编译专用 WebGPU WASM。

## 状态

仓库已建立；模型权重尚未转换或上传。当前 Release 直链在文件上传前不会可用。
