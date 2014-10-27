from PIL import Image
from PIL.ExifTags import TAGS
import os, glob, json
from operator import itemgetter
from datetime import datetime

imageDir = 'images'

def addMetadata(picPath):
	img = Image.open(picPath)

	exif_data = img._getexif()

	exif = {
		TAGS[k]: v
		for k, v in exif_data.items()
		if k in TAGS
	}

	print(exif['DateTimeOriginal'])

	date = [int(y) for x in exif['DateTimeOriginal'].split(' ') for y in x.split(':')]
	date = datetime(date[0], date[1], date[2], date[3], date[4], date[5])

	data = {
		'image': {
			'src': picPath,
			'width': exif['ExifImageWidth'],
			'height': exif['ExifImageHeight'],
		},
		'date': date.isoformat(),
		'colspan': 4,
		'rowspan': 3
	}

	img.thumbnail((80, 80))
	img.save('../compiled/'+picPath, "JPEG", quality=80, optimize=True, progressive=True)

	return data

metadata = [addMetadata(picPath) for picPath in glob.glob(os.path.join(imageDir, '*'))]
metadata = sorted(metadata, key=itemgetter('date')) 

jsonFile = open("metadata.json", "w")
jsonFile.write(json.dumps(metadata))
jsonFile.close()