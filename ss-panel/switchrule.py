def getKeys(key_list):
	#return key_list
	return key_list + ['plan'] # append the column name 'plan'

def isTurnOn(row):
	#return True
	return row['plan'] == 'D' or row['plan']== 'E'  # then judge here
