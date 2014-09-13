from PIL import Image
from PIL.ExifTags import TAGS
import os, glob, json
from operator import itemgetter
from datetime import datetime

def addMetadata(pic):
	img = Image.open(pic)

	exif_data = img._getexif()

	data = {
		TAGS[k]: v
		for k, v in exif_data.items()
		if k in TAGS
	}

	exif = {
		'image': {
			'src': pic,
			'width': data['ExifImageWidth'],
			'height': data['ExifImageHeight'],
		},
		'date': data['DateTimeOriginal'],
		'colspan': 4,
		'rowspan': 3
	}

	return exif

metadata = [addMetadata(pic) for pic in glob.glob(os.path.join('images', '*.JPG'))]
metadata = sorted(metadata, key=itemgetter('date')) 

jsonFile = open("metadata.json", "w")
jsonFile.write(json.dumps(metadata))
jsonFile.close()
	