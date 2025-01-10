FROM python:3.8

COPY ./requirements.txt /webapp/requirements.txt

WORKDIR /webapp

RUN pip install -r requirements.txt

COPY webapp/* /webapp

COPY roberta-sequence-classification-9.onnx /webapp

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]

#The Dockerfile copies the requirements file, creates a webapp directory, 
#and copies the application code into a single app.py file