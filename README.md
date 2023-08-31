<!-- omit in toc -->
# eVTOL Workpace

**Table of Contents**
- [Instalação](#instalação)
  - [Requisitos](#requisitos)
  - [Clone o repositório](#clone-o-repositório)
  - [(Opcional) Modifique a imagem que irá usar](#opcional-modifique-a-imagem-que-irá-usar)
  - [Configurar para uso de GPU](#configurar-para-uso-de-gpu)
    - [Ubuntu](#ubuntu)
    - [Outras distribuições](#outras-distribuições)
  - [Inicialize o container](#inicialize-o-container)
  - [Configure suas credenciais do GitHub](#configure-suas-credenciais-do-github)
  - [Faça o setup](#faça-o-setup)
- [Tasks](#tasks)
- [Workflows para CI](#workflows-para-ci)

## Instalação

### Requisitos
- VSCode
- [Docker](https://docs.docker.com/engine/install/)
- Extensão [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) para VSCode

### Clone o repositório

Clone o repositório normalmente.

### (Opcional) Modifique a imagem que irá usar

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

### Configurar para uso de GPU

Caso você queira usar a GPU para acelerar a renderização gráfica do simulador, é necessário instalar os drivers da Nvidia e o Nvidia Container Toolkit. Instale os drivers antes do Nvidia CTK.

#### Ubuntu 

Configure o repositório do pacote:

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

Atualize a listagem dos pacotes:

```bash
sudo apt-get update
```

Caso esse comando retorne algum erro referente a um conflito do `Signed-By`, leia esta [página](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/troubleshooting.html#conflicting-signed-by).

Instale o Container Toolkit:

```bash
sudo apt-get install -y nvidia-container-toolkit
```

Por fim, rode:

```bash
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Para testar a instalação, use:

```bash
sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

#### Outras distribuições

Para mais informações sobre a instalação, acesse esse [link](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).


### Inicialize o container

Cline no ícone no canto inferior direito e selecione a opção `Rebuild with container`.

### Configure suas credenciais do GitHub

Há duas formas de configurar suas credenciais: utilizando HTTPS ou SSH.

Link: [Sharing Git credentials with your container](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)

### Faça o setup

Para realizar o setup do workspace, foram criadas duas tasks: `Setup` e `Setup (sem simulador)`. Para rodá-las, digite `Ctrl+Shift+P`, selecione `Tasks: Run Tasks` e procure pelo setup que você deseja realizar.

## Tasks

Existem várias tasks pré definidas. Em `.vscode/tasks.json`, você terá uma lista completa das taks. Em geral, as principais são:

- `setup`: clona as dependências e faz o build inicial
- `build`: compila o projeto
- `simulate`: inicializa o simulador
- `agent`: inicializa o Micro-XRCE-DDS-Agent, necessário para a comunicação entre o ROS2 e a PX4

Em geral, ao longo do desenvolvimento com simulador, você fará o seguinte:

1. Rodar a task `simulate`
2. Rodar a task `agent`
3. Rodar seu código usando o comando
```bash
ros2 run <nome-do-pacote> <nome-do-executavel>
```

## Workflows para CI

Esse repositório possui um workflow que é acionado ao fazer `push` nas branches `main` e `development` e ao fazer um `pull request`. Esse workflow compila o projeto e roda os testes, em um processo que demora cerca de uma hora.

Em certas ocasiões, não é desejável acionar o workflow, pois nossa organização tem 2000 minutos mensais para usar com Workflows e queremos fazer um commit simples (por exemplo, quando as alterações são apenas documentação). Nesse caso, você deve incluir a string `[skip ci]` em qualquer parte da sua mensagem de commit em um `push` ou no HEAD commit de um `pull request`.

