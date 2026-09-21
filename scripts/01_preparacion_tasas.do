* ==============================================================================
* Proyecto: Impacto de Tasas de Interés BCRP vs FED
* Script: 01_preparacion_tasas.do
* ==============================================================================

* 1. Configurar el directorio principal (Quien use el código cambiará esta ruta)
* cd "C:/Ruta/A/Tu/Carpeta/Principal" 

* ------------------------------------------------------------------------------
* FASE 1: Limpieza de la data de la Fed (desde data_cruda)
* ------------------------------------------------------------------------------
import excel "data_cruda/DFEDTARU.xlsx", sheet(Monthly) firstrow clear

* Convertir la fecha de la Fed (texto) a formato mensual numérico de Stata
gen fecha_temp = date(observation_date, "DMY")
gen fecha = mofd(fecha_temp)
format fecha %tmMon_CCYY

* Renombrar y guardar temporalmente para poder cruzarla
rename DFEDTARU tasa_fed
drop observation_date fecha_temp
save "data_tratada/fed_temp.dta", replace

* ------------------------------------------------------------------------------
* FASE 2: Descarga de BCRP y Cruce de bases
* ------------------------------------------------------------------------------
clear
* Usar tu paquete para traer la data del BCRP
dbcrp PD04722MM 2021-1 2026-8
rename PD04722MM tasa_bcrp

* Formatear la fecha para que visualmente cuadre con la Fed
format fecha %tmMon_CCYY

* UNIÓN AUTOMÁTICA (Reemplaza el copiar y pegar)
merge 1:1 fecha using "data_tratada/fed_temp.dta"
drop _merge 
erase "data_tratada/fed_temp.dta" // Borramos el temporal para mantener limpio

* ------------------------------------------------------------------------------
* FASE 3: Etiquetas, Notas y Guardado Final (hacia data_tratada)
* ------------------------------------------------------------------------------
label variable tasa_bcrp "Tasa de referencia (BCRP)"
label variable tasa_fed "Tasa FED (Límite Superior)"

note tasa_fed : Federal Funds Target Range - Upper Limit, Percent, Monthly, Not Seasonally Adjusted, End of Period
notes _dta : "Rango temporal: Enero 2021 - Agosto 2026. Frecuencia mensual."

save "data_tratada/tasas_bcrp_fed_mensual.dta", replace

* ------------------------------------------------------------------------------
* FASE 4: Visualización (hacia graficos)
* ------------------------------------------------------------------------------
tsset fecha

twoway (line tasa_bcrp fecha, lcolor(maroon) lwidth(medthick)) ///
       (line tasa_fed fecha, lcolor(navy) lwidth(medthick)), ///
       ytitle("Tasa de Interés (%)") ///
       xtitle("") ///
       legend(order(1 "BCRP" 2 "Fed (Límite Superior)") region(lcolor(none))) ///
       tlabel(2021m1(6)2026m8, format(%tmMon_CCYY) angle(45) labsize(small)) ///
       graphregion(color(white))

graph export "graficos/grafico1_tasas_fed_bcrp.png", as(png) replace
