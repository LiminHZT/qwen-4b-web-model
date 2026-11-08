# Qwen3.5 4B WebLLM Model

目标模型：`HauhauCS/Qwen3.5-4B-Uncensored-HauhauCS-Aggressive`（仓库名不带 `-GGUF`）。

页面模型目录：`https://github.com/LiminHZT/qwen-4b-web-model/releases/download/v1.0/`。

## 已核验的模型源

作者仓库目前只提供 GGUF，没有 Transformers 所需的 `config.json` 和 Safetensors。可使用已核验的 Safetensors 重建版本：

`DreamFast/Qwen3.5-4B-Uncensored-HauhauCS-Aggressive-Safetensor-Benchmark`

其中包含 `config.json`、`model.safetensors`、tokenizer 与多模态配置。

## 转换与发布

`mlc_llm convert_weight` 应读取 Hugging Face Transformers 模型目录，而不是 Q4_K_M GGUF。避免从有损 GGUF 二次量化。

在具有足够内存和磁盘的机器上运行：

```bash
git clone https://github.com/LiminHZT/qwen-4b-web-model.git
cd qwen-4b-web-model
bash convert-and-release.sh
```

脚本默认通过 `https://hf-mirror.com` 下载源模型，转换为 `q4f16_1`，生成 WebLLM 配置，并把全部产物上传至 `v1.0` Release。

产物包括 `mlc-chat-config.json`、`tensor-cache.json`（或旧版的 `ndarray-cache.json`）、`params_shard_*.bin` 和 tokenizer 文件。保留 MLC 权重分片，不要合并成单个大文件；Releases 不需要 Git LFS。

WebLLM 0.2.87 可复用同架构运行库：

`https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/main/web-llm-models/v0_2_87/base/Qwen3.5-4B-q4f16_1_cs1k-webgpu.wasm`

若转换配置与官方 Qwen3.5-4B 不一致，则需针对转换后的 `mlc-chat-config.json` 编译专用 WebGPU WASM。

## 状态

仓库及转换脚本已建立；模型权重尚未转换或上传。Release 直链将在文件上传后可用。
