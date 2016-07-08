def getKeys():
	return ['port', 'u', 'd', 'transfer_enable', 'passwd', 'enable', 'plan' ]
	#return ['port', 'u', 'd', 'transfer_enable', 'passwd', 'enable', 'plan'] # append the column name 'plan'

def isTurnOn(row):
      return row['plan'] == 'D' or row['plan']== 'E'
      #return row['plan'] == 'B' # then judge here