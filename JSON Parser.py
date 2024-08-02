import pandas as pd
import json

#Opens json file
file_path = r"C:\Users\crinionr\Desktop\Mallory Projet\Mallory_Search.json"
f = open(file_path)
data = json.load(f)

#Enters json as Python dict
dataList = data['data']

list = []

for entry in dataList:
    dict = {}
    for x in entry:

        #Grabs display name
        dict['Name'] = entry['displayName']

        #Grabs asset type
        dict['Asset Type'] = entry['assetType']

        #Grabs location
        dict['Location'] = entry['locationDisplayValue']
        
        #Grabs manufacturer
        dict['Manufacturer'] = entry['manufacturerName']

        #Grabs model
        dict['Model'] = entry['productName']

        #Grabs serial number
        if len(entry['serialNumber']) > 0:
            dict['Serial Number'] = entry['serialNumber'][0]
        else:
            dict['Serial Number'] = ""

        #Grabs PO Number and Asset Tag
        complex_data_fields = entry['searchComplexDataFields']
        for field in complex_data_fields:
            if len(field) > 0:
                key = field.get('contextId')
                value = field.get('propertyValue')
                if len(key) == 9 and len(str(value[0])) == 6:
                    dict[key] = value[0]
                else:
                    dict[key] = ""    
            else:
                dict[""] = ""

    list.append(dict)

#Error checking    
#print(list)

#print(f"Total entries processed: {len(list)}")
#print(f"Total entries in dataList: {len(dataList)}")

df = pd.DataFrame(list)
df.to_excel('output.xlsx', index=False, sheet_name='Sheet1')

