PGDMP             
    
        w            week10    12.0    12.0     ,           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            -           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            .           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            /           1262    16596    week10    DATABASE     �   CREATE DATABASE week10 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE week10;
                postgres    false            	            2615    16597    census    SCHEMA        CREATE SCHEMA census;
    DROP SCHEMA census;
                postgres    false            �            1259    16599    facts    TABLE     �   CREATE TABLE census.facts (
    fact_type_id integer NOT NULL,
    tract_id character varying(11) NOT NULL,
    yr integer NOT NULL,
    val numeric(12,3),
    perc numeric(6,2)
);
    DROP TABLE census.facts;
       census         heap    postgres    false    9            �            1259    16602    lu_fact_types    TABLE     �   CREATE TABLE census.lu_fact_types (
    fact_type_id integer NOT NULL,
    category character varying(100),
    fact_subcats character varying(255)[],
    short_name character varying(20)
);
 !   DROP TABLE census.lu_fact_types;
       census         heap    postgres    false    9            �            1259    16608    lu_fact_types_fact_type_id_seq    SEQUENCE     �   CREATE SEQUENCE census.lu_fact_types_fact_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE census.lu_fact_types_fact_type_id_seq;
       census          postgres    false    9    206            0           0    0    lu_fact_types_fact_type_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE census.lu_fact_types_fact_type_id_seq OWNED BY census.lu_fact_types.fact_type_id;
          census          postgres    false    207            �            1259    16610 	   lu_tracts    TABLE     �   CREATE TABLE census.lu_tracts (
    tract_id character varying(11) NOT NULL,
    tract_long_id character varying(25),
    tract_name character varying(150)
);
    DROP TABLE census.lu_tracts;
       census         heap    postgres    false    9            �            1259    16757    vw_facts    VIEW       CREATE VIEW census.vw_facts AS
 SELECT lf.fact_type_id,
    lf.category,
    lf.fact_subcats,
    lf.short_name,
    f.tract_id,
    f.yr,
    f.val,
    f.perc
   FROM (census.facts f
     JOIN census.lu_fact_types lf ON ((f.fact_type_id = lf.fact_type_id)));
    DROP VIEW census.vw_facts;
       census          postgres    false    205    206    206    206    206    205    205    205    205    9            �
           2604    16625    lu_fact_types fact_type_id    DEFAULT     �   ALTER TABLE ONLY census.lu_fact_types ALTER COLUMN fact_type_id SET DEFAULT nextval('census.lu_fact_types_fact_type_id_seq'::regclass);
 I   ALTER TABLE census.lu_fact_types ALTER COLUMN fact_type_id DROP DEFAULT;
       census          postgres    false    207    206            �
           2606    16751    facts pk_facts 
   CONSTRAINT     d   ALTER TABLE ONLY census.facts
    ADD CONSTRAINT pk_facts PRIMARY KEY (fact_type_id, tract_id, yr);
 8   ALTER TABLE ONLY census.facts DROP CONSTRAINT pk_facts;
       census            postgres    false    205    205    205            �
           2606    16753    lu_fact_types pk_lu_fact_types 
   CONSTRAINT     f   ALTER TABLE ONLY census.lu_fact_types
    ADD CONSTRAINT pk_lu_fact_types PRIMARY KEY (fact_type_id);
 H   ALTER TABLE ONLY census.lu_fact_types DROP CONSTRAINT pk_lu_fact_types;
       census            postgres    false    206            �
           2606    16755    lu_tracts pk_lu_tracts 
   CONSTRAINT     Z   ALTER TABLE ONLY census.lu_tracts
    ADD CONSTRAINT pk_lu_tracts PRIMARY KEY (tract_id);
 @   ALTER TABLE ONLY census.lu_tracts DROP CONSTRAINT pk_lu_tracts;
       census            postgres    false    208            �
           1259    16768    idx_lu_fact_types    INDEX     Q   CREATE INDEX idx_lu_fact_types ON census.lu_fact_types USING gin (fact_subcats);
 %   DROP INDEX census.idx_lu_fact_types;
       census            postgres    false    206           