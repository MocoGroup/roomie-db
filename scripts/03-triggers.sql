CREATE OR REPLACE FUNCTION fn_sincronizar_vagas_imovel()
RETURNS TRIGGER AS $$
BEGIN
    -- Contrato novo sendo ATIVADO
    IF TG_OP = 'INSERT' AND NEW.status_contrato = 'ACTIVE' THEN
        UPDATE imovel
        SET vagas_disponiveis = vagas_disponiveis - 1
        WHERE id_imovel = NEW.id_imovel
          AND vagas_disponiveis > 0;

        -- Se zerou as vagas, marca imóvel como RENTED
        UPDATE imovel
        SET status = 'RENTED'
        WHERE id_imovel = NEW.id_imovel
          AND vagas_disponiveis = 0;

    -- Contrato passa de ACTIVE para FINISHED ou CANCELLED
    ELSIF TG_OP = 'UPDATE'
        AND OLD.status_contrato = 'ACTIVE'
        AND NEW.status_contrato IN ('FINISHED', 'CANCELLED') THEN

        UPDATE imovel
        SET vagas_disponiveis = vagas_disponiveis + 1,
            status = CASE
                WHEN status = 'RENTED' THEN 'ACTIVE'
                ELSE status
            END
        WHERE id_imovel = NEW.id_imovel;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_vagas_contrato
AFTER INSERT OR UPDATE OF status_contrato ON contrato_locacao
FOR EACH ROW
EXECUTE FUNCTION fn_sincronizar_vagas_imovel();
