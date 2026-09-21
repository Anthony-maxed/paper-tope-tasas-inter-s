# En proceso

## Estructura del Proyecto
* `data_cruda/`: Archivos originales inmutables (Serie histórica de la Reserva Federal).
* `data_tratada/`: Bases de datos consolidadas, unificadas temporalmente y etiquetadas en formato `.dta`.
* `scripts/`: Códigos de Stata (`.do`) diseñados para la limpieza, el cruce automático de bases y la visualización.
* `graficos/`: Salidas visuales en formato `.png` listas para documentación.

## Fuentes de Datos
* **Reserva Federal (Fed):** Federal Funds Target Range - Upper Limit (Frecuencia Mensual).
* **Banco Central de Reserva del Perú (BCRP):** Tasa de Referencia de Política Monetaria (Frecuencia Mensual). Extraída mediante conexión directa con la API institucional usando el paquete de Stata `dbcrp`.
* **Cobertura temporal de la muestra:** Enero 2021 - Agosto 2026.

## Instrucciones de Reproducción
Para replicar la consolidación de datos y las figuras:
1. Descarga o clona este repositorio en tu entorno local.
2. Abre el script de preparación ubicado en la carpeta `scripts/` utilizando Stata.
3. Ajusta la ruta del directorio de trabajo (`cd`) al inicio del script para apuntar a la carpeta raíz del proyecto.
4. Ejecuta el archivo de principio a fin. El código actualizará las bases de datos y exportará los gráficos automáticamente a sus respectivos directorios.
