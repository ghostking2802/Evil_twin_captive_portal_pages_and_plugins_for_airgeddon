#!/usr/bin/env bash

# Sort-Targets airgeddon plugin

# Version:    0.1.2
# Author:     KeyofBlueS
# Repository: https://github.com/KeyofBlueS/airgeddon-plugins
# License:    GNU General Public License v3.0, https://opensource.org/licenses/GPL-3.0

# airgeddon Repository: https://github.com/v1s1t0r1sh3r3/airgeddon

#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

plugin_name="Sort-Targets"
plugin_description="Sort targets by a value of Your choice"
plugin_author="KeyofBlueS"

plugin_enabled=1

plugin_minimum_ag_affected_version="10.30"
plugin_maximum_ag_affected_version=""
plugin_distros_supported=("*")

################################# USER CONFIG SECTION #################################

# When selecting targets, sort them by one of the following value:
# "bssid", "channel", "power", "essid", "encryption", "default"
# or:
# "menu"
# if You want to choose sorting within a menu, this override reverse option too.
# Example:
#sort_by="power"
sort_by=menu

# Set reverse to "true" to reverse the result of comparisons, otherwise set to "false"
# Example:
reverse=false

# If You set sort_by="menu", You can make remember Your sort choice in current session
# by set remember_sort to "true", otherwise set to "false"
# Example:
remember_sort=false

############################## END OF USER CONFIG SECTION ##############################

#Sort targets
function sort_targets_prehook_select_target() {

	debug_print

	stored_sort_by="${sort_by}"
	stored_reverse="${reverse}"
	if [[ "${sort_by}" = "menu" ]]; then
		while true; do
			clear
			echo 
			language_strings "${language}" "sort_targets_text_0" "green"
			echo
			print_simple_separator
			language_strings "${language}" "sort_targets_text_1"
			language_strings "${language}" "sort_targets_text_2"
			language_strings "${language}" "sort_targets_text_3"
			language_strings "${language}" "sort_targets_text_4"
			language_strings "${language}" "sort_targets_text_5"
			language_strings "${language}" "sort_targets_text_6"
			print_simple_separator
			read -rp "> " sort_by

			case $sort_by in
				1)
					sort_by="bssid"; reverse=false; break
				;;
				2)
					sort_by="channel"; reverse=false; break
				;;
				3)
					sort_by="power"; reverse=false; break
				;;
				4)
					sort_by="essid"; reverse=false; break
				;;
				5)
					sort_by="encryption"; reverse=false; break
				;;
				6)
					sort_by="default"; reverse=false; break
				;;
				7)
					sort_by="bssid"; reverse=true; break
				;;
				8)
					sort_by="channel"; reverse=true; break
				;;
				9)
					sort_by="power"; reverse=true; break
				;;
				10)
					sort_by="essid"; reverse=true; break
				;;
				11)
					sort_by="encryption"; reverse=true; break
				;;
				12)
					sort_by="default"; reverse=true; break
				;;
				*)
					echo
					language_strings "${language}" "sort_targets_text_7" "red"
					language_strings "${language}" 115 "read"
				;;
			esac
		done
	fi
	
	if [[ "${sort_by}" = "bssid" ]]; then
		sort_options="-d -k 1"
	elif [[ "${sort_by}" = "channel" ]]; then
		sort_options="-n -k 2"
	elif [[ "${sort_by}" = "power" ]]; then
		sort_options="-n -k 3"
	elif [[ "${sort_by}" = "essid" ]]; then
		sort_options="-d -k 4"
	elif [[ "${sort_by}" = "encryption" ]]; then
		sort_options="-d -k 5"
	else
		sort_options="-d -k 4"
	fi
	
	if [[ "${reverse}" = "true" ]]; then
		sort_options="${sort_options} -r"
	fi

	sort -t "," ${sort_options} "${tmpdir}wnws.txt" > "${tmpdir}wnws.txt_tmp"
	mv "${tmpdir}wnws.txt_tmp" "${tmpdir}wnws.txt"
	
	unset sort_options
	
	if [[ "${remember_sort}" = "false" ]]; then
		sort_by="${stored_sort_by}"
		reverse="${stored_reverse}"
	fi
}

#Custom function. Create text messages to be used in sort targets plugin
function initialize_sort_targets_language_strings() {

	debug_print

	arr["ENGLISH","sort_targets_text_0"]="Select the order in which to display the list of targets:"
	arr["SPANISH","sort_targets_text_0"]="\${pending_of_translation} Seleccione el orden en el que se mostrar?? la lista de objetivos:"
	arr["FRENCH","sort_targets_text_0"]="\${pending_of_translation} S??lectionnez l'ordre dans lequel afficher la liste des cibles:"
	arr["CATALAN","sort_targets_text_0"]="\${pending_of_translation} Seleccioneu l???ordre en qu?? es mostrar?? la llista d???objectius:"
	arr["PORTUGUESE","sort_targets_text_0"]="\${pending_of_translation} Selecione a ordem na qual exibir a lista de destinos:"
	arr["RUSSIAN","sort_targets_text_0"]="\${pending_of_translation} ???????????????? ?????????????? ?????????????????????? ???????????? ??????????:"
	arr["GREEK","sort_targets_text_0"]="\${pending_of_translation} ???????????????? ???? ?????????? ???? ?????? ?????????? ???? ???????????????????? ?? ?????????? ?????? ????????????:"
	arr["ITALIAN","sort_targets_text_0"]="Seleziona lordine in cui visualizzare l'elenco degli obbiettivi:"
	arr["POLISH","sort_targets_text_0"]="\${pending_of_translation} Wybierz kolejno???? wy??wietlania listy cel??w:"
	arr["GERMAN","sort_targets_text_0"]="\${pending_of_translation} W??hlen Sie die Reihenfolge aus, in der die Liste der Ziele angezeigt werden soll:"
	arr["TURKISH","sort_targets_text_0"]="\${pending_of_translation} Hedef listesinin g??r??nt??lenece??i s??ray?? se??in:"
	arr["ARABIC","sort_targets_text_0"]="\${pending_of_translation} ?????? ?????????????? ???????? ???????? ?????? ?????????? ?????????????? ????"

	arr["ENGLISH","sort_targets_text_1"]=" 1) bssid       7) bssid (reverse)"
	arr["SPANISH","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_1"]=" 1) bssid       7) bssid (invertito)"
	arr["POLISH","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_1"]=" 1) bssid       7) bssid (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_2"]=" 2) channel     8) channel (reverse)"
	arr["SPANISH","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_2"]=" 2) channel     8) channel (invertito)"
	arr["POLISH","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_2"]=" 2) channel     8) channel (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_3"]=" 3) power       9) power (reverse)"
	arr["SPANISH","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_3"]=" 3) power       9) power (invertito)"
	arr["POLISH","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_3"]=" 3) power       9) power (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_4"]=" 4) essid      10) essid (reverse)"
	arr["SPANISH","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_4"]=" 4) essid      10) essid (invertito)"
	arr["POLISH","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_4"]=" 4) essid      10) essid (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_5"]=" 5) encryption 11) encryption (reverse)"
	arr["SPANISH","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_5"]=" 5) encryption 11) encryption (invertito)"
	arr["POLISH","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_5"]=" 5) encryption 11) encryption (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_6"]=" 6) default    12) default (reverse)"
	arr["SPANISH","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} inverso)"
	arr["FRENCH","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} inverser)"
	arr["CATALAN","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} rev??s)"
	arr["PORTUGUESE","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} reverter)"
	arr["RUSSIAN","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} ????????????????)"
	arr["GREEK","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} ??????????????????????)"
	arr["ITALIAN","sort_targets_text_6"]=" 6) default    12) default (invertito)"
	arr["POLISH","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} odwrotno????)"
	arr["GERMAN","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} umgekehrt)"
	arr["TURKISH","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} ters)"
	arr["ARABIC","sort_targets_text_6"]=" 6) default    12) default (\${cyan_color}\${pending_of_translation}\${normal_color} ????????)"

	arr["ENGLISH","sort_targets_text_7"]="Invalid choice!"
	arr["SPANISH","sort_targets_text_7"]="\${pending_of_translation} ??Elecci??n inv??lida!"
	arr["FRENCH","sort_targets_text_7"]="\${pending_of_translation} Choix invalide!"
	arr["CATALAN","sort_targets_text_7"]="\${pending_of_translation} Elecci?? no v??lida!"
	arr["PORTUGUESE","sort_targets_text_7"]="\${pending_of_translation} Escolha inv??lida!"
	arr["RUSSIAN","sort_targets_text_7"]="\${pending_of_translation} ???????????????? ??????????!"
	arr["GREEK","sort_targets_text_7"]="\${pending_of_translation} ???? ???????????? ??????????????!"
	arr["ITALIAN","sort_targets_text_7"]="Scelta non valida!"
	arr["POLISH","sort_targets_text_7"]="\${pending_of_translation} Nieprawid??owy wyb??r!"
	arr["GERMAN","sort_targets_text_7"]="\${pending_of_translation} Ung??ltige Wahl!"
	arr["TURKISH","sort_targets_text_7"]="\${pending_of_translation} Ge??ersiz se??im!"
	arr["ARABIC","sort_targets_text_7"]="\${pending_of_translation} ???????????? ?????? ????????"
}

initialize_sort_targets_language_strings
