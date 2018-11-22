# Proyecto de Verificación Funcional

# Proyecto 1 - SDRAM Controller

## Estrategia de verificación

Se realizan transacciones por el controlador **SDRAM**. Se utiliza un **BMF** de _Wishbone_. Basado en el testbench entregado, se le realiza un ambiente de verificación que incluye instancias de _environment_, _driver_, _scoreboard_ y _monitor_.

### Environment

Crea las instancias y configuración del Driver, Scoreboard y Monitor.

### Driver
Contiene los métodos

* Reset: inicializa la memoria DRAM
* Burst_write: ejecuta una escritura a la memoria DRAM y almacena la información de la escritura en el scoreboard.

### Monitor
Contiene los métodos

* Burst_read: ejecuta una escritura a la memoria DRAM y compara con la información obtenida de la lectura con la información de la escritura almacenada en el scoreboard

### Scoreboard
incluye una cola para datos, dirección, tamaño de ráfaga de escritura.



![](https://raw.githubusercontent.com/manchii/Proyecto_VF/master/images/diagram.png)


# Proyecto 2

## Estrategia de verificación

Se realiza una extensión del ambiente de verificación del proyecto 1

![](https://github.com/manchii/Proyecto_VF/blob/master/images/diagram2.png)
