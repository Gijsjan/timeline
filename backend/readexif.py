from PIL import Image
from PIL.ExifTags import TAGS
import os, glob, json
from operator import itemgetter
from datetime import datetime

def addMetadata(pic):
	img = Image.open(pic)

	exif_data = img._getexif()

	exif = {
		TAGS[k]: v
		for k, v in exif_data.items()
		if k in TAGS
	}

	print(exif)

	date = [int(y) for x in exif['DateTimeOriginal'].split(' ') for y in x.split(':')]
	date = datetime(date[0], date[1], date[2], date[3], date[4], date[5])

	data = {
		'image': {
			'src': pic,
			'width': exif['ExifImageWidth'],
			'height': exif['ExifImageHeight'],
		},
		'date': date.isoformat(),
		'colspan': 4,
		'rowspan': 3
	}

	img.thumbnail((80, 80))
	img.save('../compiled/'+pic, "JPEG", quality=80, optimize=True, progressive=True)

	return data

metadata = [addMetadata(pic) for pic in glob.glob(os.path.join('images', '*'))]
metadata = sorted(metadata, key=itemgetter('date')) 

jsonFile = open("metadata.json", "w")
jsonFile.write(json.dumps(metadata))
jsonFile.close()