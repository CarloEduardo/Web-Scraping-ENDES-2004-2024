* Project: Web-Scraping-ENDES-2004-2024
* Author: Carlos Eduardo Torres Garcia 
* Email: carlo.eduardo749@gmail.com
* GitHub: CarloEduardo
* Last modified: May 2026
* Acknowledgment: Edinson Tolentino
********************************************************************************

cls
clear all
set more off

global Path    = "C:\Users\CARLO EDUARDO\Desktop\01. Web Scraping ENDES" 
global Dataset = "$Path\01. ENDES"

capture mkdir "$Dataset"

********************************************************************************
* Years:
********************************************************************************
* (2004/2005/2006/2007/2008/2009/2010/2011/2012/2013/2014/2015/2016/2017/2018/2019/2020/2021/2022/2023/2024)	
mat ENDES_YEARS = (120\150\183\194\209\238\260\290\323\407\441\504\548\605\638\691\739\760\786\910\968)

********************************************************************************
* Modules:
********************************************************************************
*1. Module	1629 – Caracteristicas del Hogar				
*2. Module	1630 – Caracteristicas de la Vivienda				
*3. Module	1631 – Datos Basicos de MEF				
*4. Module	1632 – Historia de Nacimiento - Tabla de Conocimiento de Metodo				
*5. Module	1633 – Embarazo, Parto, Puerperio y Lactancia				
*6. Module	1634 – Inmunización y Salud				
*7. Module	1635 – Nupcialidad - Fecundidad - Cónyugue y Mujer				
*8. Module	1636 – Conocimiento de Sida y uso del condón				
*9. Module	1637 – Mortalidad Materna - Violencia Familiar				
*10. Module	1638 – Peso y talla - Anemia				
*11. Module	1639 – Disciplina Infantil				
*12. Module	1640 – Encuesta de salud				
*13. Module	1641 – Programas Sociales				
mat ENDES_MODULES = J(21,13,.)

mat ENDES_MODULES[1,1]     = (64,65,66,67,69,70,71,72,73, .,  .,  .,.)
mat base_modules_2005_2012 = (64,65,66,67,69,70,71,72,73,74,  .,  .,.)
mat ENDES_MODULES[10,1]    = (64,65,66,67,69,70,71,72,73,74,413,414,.)
mat base_modules_2014_2019 = (64,65,66,67,69,70,71,72,73,74,413,414,569)	
mat base_modules_2020_2024 = (1629,1630,1631,1632,1633,1634,1635,1636,1637,1638,1639,1640,1641)

forvalues r = 2(1)9 {
    mat ENDES_MODULES[`r',1] = base_modules_2005_2012
}
forvalues r = 11(1)16 {
    mat ENDES_MODULES[`r',1] = base_modules_2014_2019
}
forvalues r = 17(1)21 {
    mat ENDES_MODULES[`r',1] = base_modules_2020_2024
}

matlist ENDES_YEARS
matlist ENDES_MODULES

********************************************************************************
* Download and extract ENDES modules
********************************************************************************

forvalues i = 4(1)24 {
    local year = 2000 + `i'
    local t    = `i' - 3 
    
    capture mkdir "$Dataset/`year'"
    cd            "$Dataset/`year'"
    
    local survey_id = ENDES_YEARS[`t',1]
    
	* Here you can choose which modules you want to download
	foreach j in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
        
        local survey_mod = ENDES_MODULES[`t',`j']
        
        display "Year: `year' - Survey ID: `survey_id' - Module: `survey_mod'"
		
		if !missing(`survey_mod') {
			if `year' >= 2004 &  `year' <= 2020 {
				copy https://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/`survey_id'-Modulo`survey_mod'.zip       ENDES_`year'_Modulo`survey_mod'.zip, replace									
			}
			
			if `year' == 2021 {
				copy https://iinei.inei.gob.pe/iinei/srienaho/descarga/STATA/`survey_id'-Modulo`survey_mod'.zip      ENDES_`year'_Modulo`survey_mod'.zip, replace				
			}
			
			if `year' >= 2022 {
				copy https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/`survey_id'-Modulo`survey_mod'.zip  ENDES_`year'_Modulo`survey_mod'.zip, replace
			}
		 }
									
		cap unzipfile ENDES_`year'_Modulo`survey_mod'.zip, replace
		
		if _rc == 0 {
			*erase ENDES_`year'_Modulo`survey_mod'.zip
		} 
		else {
			display as error "Error during extraction. Please manually extract the file: ENDES_`year'_Modulo`survey_mod'.zip"
		}
    }
}

									
