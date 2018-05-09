# GROCERIES

## Fallos por ahora:

### Test modelo
	- Validar long. y presencia de los lados. No está indicado en el test, lo comprueba por que lo comprueba el modelo

### Test controlador
	- UPDATE: El body en caso de 422 está formado por un JSON a partir del objeto errors de ActiveModel

### Pundit
	- Devolver 204: Está puesto a piñon que devuelva el body vacío y el stado 204.
