--CREATE DATABASE "quotesify_database";

--The Authorizations table lists the available types of companies
--that the admin can create

 CREATE TABLE "authorizations" (
                    "authorization_id" SERIAL PRIMARY KEY,
                    "type_of_company" VARCHAR (80) UNIQUE NOT NULL
                );
                
                INSERT INTO "authorizations" ("type_of_company")
                VALUES 
                ('Administrator'), ('Employer'), ('Broker'), ('Provider');
                
                
                --  Companies table lists companies and their associated authorizations
                CREATE TABLE "companies" (
                    "company_id" SERIAL PRIMARY KEY,
                    "name" VARCHAR (80) NOT NULL,
                    "authorization_id" INTEGER references authorizations
                );
                
                INSERT INTO "companies" ("name", "authorization_id")
                VALUES
                ('employer1', 2),
                ('broker1', 3),
                ('provider1', 4),
                ('provider2', 4),
                ('admin1', 1);
                
                
                --  The users table lists all the users 
                --  and references the company that employs them
                --  and through that company their authorization
                --  OF NOTE:  Companies have authorizations
                --  and not users, a user may only have one company
                --  and therefore one authorization with this database
                --  setup.
                
                CREATE TABLE "users" (
                    "user_id" SERIAL PRIMARY KEY,
                    "username" VARCHAR (80) UNIQUE NOT NULL,
                    "password" VARCHAR (1000) NOT NULL,
                    "company_id" INTEGER references companies
                );
                
                --  In the code passwords must be hashed/salted
                INSERT INTO "users" ("username", "password", "company_id")
                VALUES 
                ('employer1', 'a', 1),
                ('broker1', 'a', 2),
                ('provider1', 'a', 3),
                ('provider2', 'a', 4),
                ('admin1', 'a', 5);
                
                
                --  Deal_statuses table lists the possible statuses
                --  for a deal which might be waiting for different
                --  steps to complete and might be represented
                --  as a graphic on the front end.
                
                CREATE TABLE "deal_statuses" (
                    "deal_status_id" SERIAL PRIMARY KEY,
                    "status" VARCHAR (80) UNIQUE NOT NULL
                );
                
                INSERT INTO "deal_statuses" ("status")
                VALUES 
                ('Awaiting data'), ('Ready for quote'), ('Data sent to provider');
                
                
                --  Deals table lists deals between 
                --  employers and brokers
                CREATE TABLE "deals" (
                    "deal_id" SERIAL PRIMARY KEY,
                    "employer_id" INTEGER references companies,
                    "broker_id" INTEGER references companies,
                    "date_email_sent_to_employer" DATE,
                    "deal_status_id" INTEGER references deal_statuses,
                    "csv_url" VARCHAR (1000) DEFAULT NULL
                );
                
                INSERT INTO "deals" ("employer_id", "broker_id", "date_email_sent_to_employer", "deal_status_id")
                VALUES 
                (1, 2, '01-01-2018', 1);
                
                --  Quotes table lists quotes for a deal (between a 
                --  broker and an employer) from a provider
                CREATE TABLE "quotes" (
                    "quote_id" SERIAL PRIMARY KEY,
                    "provider_id" INTEGER references companies,
                    "deal_id" INTEGER references deals,
                    "date_data_sent_to_provider" DATE,
                    "date_of_provider_decision" DATE DEFAULT NULL,
                    "sent_to_provider" BOOLEAN DEFAULT FALSE,
                    "decision_complete" BOOLEAN DEFAULT FALSE,
                    "provider_response_message" VARCHAR (1000) DEFAULT NULL,
                    "provider_response_file_location" VARCHAR (1000) DEFAULT NULL
                );
                
                INSERT INTO "quotes" (
                    "provider_id", 
                    "deal_id", 
                    "date_data_sent_to_provider",
                    "date_of_provider_decision", 
                    "sent_to_provider",
                    "decision_complete", 
                    "provider_response_message", 
                    "provider_response_file_location")
                    VALUES 
                    (3, 1, '01-04-2018', '01-05-2018', TRUE, TRUE, 'Approved', 'www.google.com'),
                    (4, 1, '01-04-2018', '01-05-2018', TRUE, TRUE, 'Denied:  Need more info', 'www.google.com');
                    