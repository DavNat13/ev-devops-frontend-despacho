# Frontend Innovatech - Gestión Logística (EV2-DEVOPS)

Este repositorio contiene la interfaz de usuario de la plataforma **Innovatech Chile**, diseñada para la gestión de ventas y despachos. El proyecto es el componente central de la Evaluación Parcial N°2 de la asignatura Introducción a Herramientas DevOps.

## 🚀 Descripción del Proyecto

El Frontend actúa como el punto de entrada para los usuarios, permitiendo la interacción con los microservicios de Ventas y Despachos. Está construido con herramientas modernas de desarrollo web y diseñado para ejecutarse en un entorno contenedorizado utilizando **Nginx** como servidor web y proxy inverso, garantizando una comunicación fluida y segura con el backend.

## 🛠️ Stack Tecnológico

- **Librería UI:** React (JavaScript).
- **Herramienta de Build:** Vite (Empaquetado rápido y optimizado).
- **Estilos:** Tailwind CSS y PostCSS.
- **Calidad de Código:** ESLint.
- **Servidor de Producción:** Nginx (Configurado como Reverse Proxy).
- **Contenedorización:** Docker (Multi-stage builds) y Docker Compose.
- **CI/CD:** GitHub Actions.
- **Infraestructura:** AWS (EC2 Pública, ECR, SSM).

## 📦 Contenedorización e Infraestructura

### Dockerfile (Multi-stage & Optimización)

El `Dockerfile` del frontend está diseñado para la máxima eficiencia y seguridad:

1.  **Etapa de Construcción (Node.js):** Utiliza Node para instalar las dependencias (`package.json`) y compilar los activos estáticos mediante Vite. En esta etapa se inyecta la IP privada del backend (`BACKEND_PRIVATE_IP`) para que la aplicación sepa dónde realizar las peticiones API.
2.  **Etapa de Producción (Nginx):** Los archivos estáticos generados (`dist/`) se transfieren a una imagen liviana de Nginx. Esto asegura que el contenedor final no contenga el código fuente ni herramientas de desarrollo innecesarias, reduciendo peso y superficie de ataque.
3.  **Configuración de Proxy:** Nginx redirige las peticiones de la API hacia los puertos correspondientes de las instancias backend en la red privada de AWS.

## ⚙️ Configuración y Ejecución Local

### Entorno de Desarrollo (Node/Vite)

Para correr el proyecto en modo desarrollo sin Docker:

```bash
npm install
npm run dev
```
## 🔄 Pipeline CI/CD (GitHub Actions)
Se implementó un flujo de entrega continua que se activa automáticamente al realizar un `push` en la rama `deploy`:

1.  **Build & Push:** Construye la imagen Docker inyectando la `BACKEND_PRIVATE_IP` desde los GitHub Secrets y la publica en Amazon ECR.
2.  **Deploy Automatizado:** Mediante **AWS Systems Manager (SSM)**, el pipeline envía las instrucciones a la instancia EC2 pública para descargar la nueva imagen y reiniciar el servicio de Nginx de forma automática y transparente.

## 🛡️ Seguridad en AWS
* **Acceso Público:** Esta es la única instancia de la arquitectura con una IP pública, actuando como puerta de enlace para los usuarios.
* **Comunicación Segura:** El Frontend se comunica con el Backend a través de la red interna de la VPC de AWS, respetando las políticas de los Security Groups que prohíben el acceso externo directo a las APIs en Java.