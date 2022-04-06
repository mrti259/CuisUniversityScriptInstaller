#!/bin/sh

nombre_ejecutable=cuis
destino_ejecutable=$HOME/.local/bin
destino_cuis=$HOME/.local/share/Cuis-University
destino_imagenes=$destino_cuis/Images

repo=Cuis-University/Cuis-University
asset_name=linux64
asset_file=$asset_name.tar.gz

# Obtener última versión
latest_tag=$(curl -s https://api.github.com/repos/$repo/releases/latest | sed -Ene '/^ *"tag_name": *"(v.+)",$/s//\1/p')

# Descargar
wget https://github.com/$repo/releases/download/$latest_tag/$asset_file

# Extraer
tar -xf $asset_file

# Crear carpeta de destino
mkdir -p $destino_cuis $destino_imagenes $destino_ejecutable

# Mover
mv $asset_name/* $destino_cuis

# Generar ejecutable
sed \
	-e "s;{latest_tag};${latest_tag#v};g" \
	-e "s;{destino_imagenes};$destino_imagenes;g" \
	-e "s;{destino_cuis};$destino_cuis;g" \
	cuis.template > $nombre_ejecutable
chmod +x $nombre_ejecutable
mv $nombre_ejecutable $destino_ejecutable
