
/* Regresión Lineal */

* Ejemplo 1

  import excel “Path\datos_regresion.xlsx", sheet("Hoja1") firstrow
  encode género, gen(cgénero)
  label drop cgénero
  recode cgénero (1=0) (2=1)
  reg peso altura edad cgénero, b

* Ejemplo 2

  use elemapi
  reg api00 acs_k3 meals full

  * Explorando los datos
    
	sum api00 acs_k3 meals full
	hist api00
	hist acs_k3
	hist meals
    hist full
	graph matrix api00 acs_k3 meals full, half
	
  * Cargamos datos consistenciados (limpios)	
	
	use elemapi2, clear
    reg api00 acs_k3 meals full

  * Comparamos ambos modelos (con y sin datos inconsistentes)
  
    use elemapi, clear
    reg api00 ause elemapics_k3 meals full
    estimates store modelo1
    
	use elemapi2, clear
    reg api00 acs_k3 meals full
    estimates store modelo2

    esttab modelo1 modelo2, p r2

* Evaluamos supuestos del modelo de regresión lineal

  use elemapi2, clear

  * Normalidad de los residuos
  
    reg api00 acs_k3 meals full
    predict r, resid
    kdensity r, normal
	pnorm r
	swilk r
	
  * Comprobamos homocedasticidad
  
    rvfplot, yline(0)
	estat imtest
	
  * Evaluamos multicolinealidad
  
    vif
	
  * Comprobamos linealidad
  
    scatter r meals
	scatter r acs_k3
	scatter r full

  * Independencia de los errores
  
    tsset snum
    dwstat

* Regresión lineal en una encuesta compleaja

  use sumaria-2021
  svyset conglome [pw= factor07], strata(estrato)
  svydescribe
  
  svy: reg gashog2d inghog2d mieperho percepho if dominio==8
  svy: reg gashog2d inghog2d mieperho percepho i.pobreza if dominio==8
  estat effects
  estat cv
  
  * Gráficos de diagnóstico
  
    predict r, resid
    predict y
    kdensity r, normal
    qnorm r

  * Evaluar multicolinealidad
  
    svy: reg inghog2d mieperho percepho if dominio==8
    display "tolerancia = " 1-e(r2) " VIF = " 1/(1-e(r2))

	svy: reg mieperho inghog2d percepho if dominio==8
    display "tolerancia = " 1-e(r2) " VIF = " 1/(1-e(r2))
 
    svy: reg percepho mieperho inghog2d if dominio==8
    display "tolerancia = " 1-e(r2) " VIF = " 1/(1-e(r2))

* Estimación en una subpoblación

  g pobre=pobreza<3
  svy, subpop(pobre): reg gashog2d inghog2d mieperho percepho if dominio==8
  estat effects

