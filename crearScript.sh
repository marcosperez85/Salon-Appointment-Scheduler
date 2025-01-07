#!/bin/bash

# Crear el archivo salon.sh con los comandos necesarios para el ejercicio
echo '#!/bin/bash' > salon.sh
chmod +x salon.sh

cat << 'EOF' >> salon.sh
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

# You should display a numbered list of the services you offer before the first prompt for input, each with the format #) <service>. For example, 1) cut, where 1 is the service_id
echo -e "\nWelcome to the Salon"
SERVICES_LIST=$($PSQL "SELECT * FROM services ORDER BY service_id" --field-separator=",")
echo "$SERVICES_LIST" | while IFS="," read -r SERVICE_ID SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done

# If you pick a service that doesn't exist, you should be shown the same list of services again

# Your script should prompt users to enter a service_id, phone number, a name if they aren’t already a customer, and a time.
# You should use read to read these inputs into variables named SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME

# If a phone number entered doesn’t exist, you should get the customers name and enter it, and the phone number, into the customers table

# You can create a row in the appointments table by running your script and entering 1, 555-555-5555, Fabio, 10:30 at each request for input if that phone number isn’t in the customers table.
# The row should have the customer_id for that customer, and the service_id for the service entered

# You can create another row in the appointments table by running your script and entering 2, 555-555-5555, 11am at each request for input if that phone number
# is already in the customers table. The row should have the customer_id for that customer, and the service_id for the service entered

# After an appointment is successfully added, you should output the message I have put you down for a <service> at <time>, <name>.
# For example, if the user chooses cut as the service, 10:30 is entered for the time, and their name is Fabio in the database the output would be I have put
# you down for a cut at 10:30, Fabio. Make sure your script finishes running after completing any of the tasks above, or else the tests won't pass
EOF

PSQL="psql -X --username=freecodecamp --dbname=postgres --no-align --tuples-only -c"

# Paso 1: Crear la base de datos
$PSQL "DROP DATABASE IF EXISTS salon"
$PSQL "CREATE DATABASE salon"

# Paso 2: Crear la tabla en la nueva base de datos
psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only << EOF
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR,
    phone VARCHAR UNIQUE
);

CREATE TABLE services(
    service_id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR
);

INSERT INTO services(name) VALUES
    ('Hair Cut'),
    ('Hair Brush'),
    ('Hair Wash');

CREATE TABLE appointments(
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) NOT NULL,
    service_id INT REFERENCES services(service_id) NOT NULL,
    time VARCHAR
);

EOF
clear

psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c "\dt"
echo -e "\nBase de datos y tablas listas para usar\n"