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
mkdir -p $destino_ejecutable $destino_cuis

# Hacer una copia de seguridad de la versión previa instalada
cp -r $destino_cuis $destino_cuis.old
rm -r $destino_cuis/*

# Mover contenido
mv $asset_name/* $destino_cuis

# Crear carpeta de imágenes
mkdir $destino_imagenes

# Generar ejecutable
sed \
	-e "s;{latest_tag};${latest_tag#v};g" \
	-e "s;{destino_imagenes};$destino_imagenes;g" \
	-e "s;{destino_cuis};$destino_cuis;g" \
	cuis.template > $nombre_ejecutable
chmod +x $nombre_ejecutable
mv $nombre_ejecutable $destino_ejecutable

# Limpiar directorio actual
rm -r $asset_name $asset_file
