# eVTOL Workpace

## Primeiro uso

### Requisitos
- VSCode
- [Docker](https://docs.docker.com/engine/install/)
- Extensão [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) para VSCode

### Clone o repositório

Clone o repositório normalmente.

### Modifique a imagem que irá usar

Abra o VSCode. Na pasta .devcontainer, você irá encontrar o arquivo Dockerfile. Faça as modificações necessárias para seu ambiente de desenvolvimento.Caso opte por não usar GPU, modifique as seguintes linhas:

```docker
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04 AS base
# FROM ubuntu:22.04 AS base
```

Mantendo as duas últimas linhas, retire as linhas após esse comentário:

```docker
###########################################
#  Full+Gazebo+Nvidia image 
###########################################
```

Por fim, no arquivo `devcontainer.json`, remova o argumento `"--gpus", "all"` de `"runArgs"`.

### Configurar para GPU

Caso você queira usar a GPU para acelerar a renderização gráfica do simulador, é necessário instalar os drivers da Nvidia e o [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

O tutorial não está completo. Você pode pular a seção sobre o CDI. Rode os seguintes comandos antes do tutorial:

```bash
sudo -i
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu22.04/nvidia-docker.list > /etc/apt/sources.list.d/nvidia-docker.list
exit
```

### Inicialize o container

Cline no ícone no canto inferior direito e selecione a opção `Rebuild with container`.

### Configure suas credenciais do GitHub

Há duas formas de configurar suas credenciais: utilizando HTTPS ou SSH.

Link: [Sharing Git credentials with your container](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)

### Faça o setup

Para realizar o setup do workspace, foram criadas duas tasks: `Setup` e `Setup (sem simulador)`. Para rodá-las, digite `Ctrl+Shift+P`, selecione `Tasks: Run Tasks` e procure pelo setup que você deseja realizar.

## Principais ferramentas

### Tasks

Existem várias tasks pré definidas. Em `.vscode/tasks.json`, você terá uma lista completa das taks. Em geral, as principais são:

- `setup`: clona as dependências e faz o build inicial
- `build`: compila o projeto
- `simulate`: inicializa o simulador
- `agent`: inicializa o Micro-XRCE-DDS-Agent, necessário para a comunicação entre o ROS2 e a PX4

### Workflows para CI

