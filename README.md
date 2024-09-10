# Data Analysis with Covid Data

Final Data Engineering Task for OTA

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

The things you need before installing the software.

* Docker Engine
* PostgreSQL
* Git

### Installation

A step by step guide that will tell you how to get the development environment up and running on Windows.
Open a terminal and run the commands below.

```
git clone https://github.com/pioesmeria/data_task.git data-task
cd data-task
cp dev.env .env
rm dev.env
```

### Dataset

Our dataset will come from the COVID-19 Data Repository by Johns Hopkins University.
Do the step below to fetch the required dataset for this project.

```
git clone https://github.com/CSSEGISandData/COVID-19.git data-task/dataset
```

You should have a folder named 'dataset' under 'data-task'.


### .env File

In the .env file, change the value of the following code to your specification:

```
POSTGRES_DB=
POSTGRES_PASSWORD=
POSTGRES_SCHEMA=
POSTGRES_USER=
```

### Running Mage.AI

On your terminal, under the first data-task folder, run the code below:

```
docker compose up
```

Once the server is running, go to http://localhost:6789 to view Mage.AI tool.

## Usage

A few examples of useful commands and/or tasks.

```
$ First example
$ Second example
$ And keep this in mind
```

## Deployment

Additional notes on how to deploy this on a live or release system. Explaining the most important branches, what pipelines they trigger and how to update the database (if anything special).

### Server

* Live:
* Release:
* Development:

### Branches

* Master:
* Feature:
* Bugfix:
* etc...

## My answers to the following data analyisis questions

What are the top 5 most common values in a particular column, and what is their frequency?
*  Using the country column as basis and the number of active column as metric, the top 5 country with 0 active case are as follows:
    * US - 310
    * China - 117
    * United Kingdom - 69
    * Canada - 46
    * New Zealand - 24

The query I used is:
```
SELECT 
	country,
	count(*) 
FROM covid_data.global_covid_data 
	WHERE num_of_active = 0 
GROUP BY 1
ORDER BY 2 DESC
```

How does a particular metric change over time within the dataset?
*  According to John Hopkins Hospital, the number of Active cases is equal to the difference between total of cases, number of death, and number of recovered. So by doing the query below and using pgAdmin4's Graph Visualizer, we can see that the number of active cases changes in accordance to the number of deaths and recovered. 

```
SELECT 
	_date, 
	SUM(num_of_active) AS active, 
	SUM(num_of_deaths) AS death, 
	SUM(num_of_recovered) AS recovered
FROM covid_data.us_covid_data
GROUP BY 1 ORDER BY _date;
```

Is there a correlation between two specific columns? Explain your findings.
* I used the number of confirmed cases and number of deaths in the US dataset. In pgAdmin4, I query the code below and the result of their correlation is 0.95. This means that for every increase of confirmed cases, the number of deaths also increases.

```
SELECT corr(num_of_confirmed, num_of_deaths)
FROM covid_data.us_covid_data;
```


