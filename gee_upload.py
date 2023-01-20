# bbest@Benjamins-MacBook-Air ~ % /opt/homebrew/bin/python3

# which pip  # /opt/homebrew/bin/pip
# pip install earthengine-api --upgrade
import ee
from google.auth.transport.requests import AuthorizedSession

# https://developers.google.com/earth-engine/Earth_Engine_asset_from_cloud_geotiff

ee.Authenticate()  #  or !earthengine authenticate --auth_mode=gcloud
session = AuthorizedSession(ee.data.get_persistent_credentials())

ee.Initialize()
print(ee.Image("NASA/NASADEM_HGT/001").get("title").getInfo())

import json
from pprint import pprint

# Request body as a dictionary.
request = {
  'type': 'IMAGE',
  'gcs_location': {
    'uris': ['gs://ee-docs-demos/COG_demo.tif']
  },
  'properties': {
    'source': 'https://code.earthengine.google.com/d541cf8b268b2f9d8f834c255698201d'
  },
  'startTime': '2016-01-01T00:00:00.000000000Z',
  'endTime': '2016-12-31T15:01:23.000000000Z',
}

pprint(json.dumps(request))

# Earth Engine enabled Cloud Project.
project_folder = 'your-project'
# A folder (or ImageCollection) name and the new asset name.
asset_id = 'cog-collection/your-cog-asset'

url = 'https://earthengine.googleapis.com/v1alpha/projects/{}/assets?assetId={}'

response = session.post(
  url = url.format(project_folder, asset_id),
  data = json.dumps(request)
)

pprint(json.loads(response.content))